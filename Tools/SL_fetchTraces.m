%% Runs irisFetch.Traces with project configuration
%  Fetches one component at a time, merges traces as necessary
%    and writes sac files to project datadir
%    filenames will use the mseed2sac convention
%
%  Rob Porritt, July 2014
function SL_fetchTraces

global config eq

% Start with user message (optional)
%msgbox('Beginning call to irisFetch.m to obtain waveform data. Traces for each component will have gaps removed, be resampled to common time windows, and written as sac files in datadir. Please have patience. Now would be an excellent time for a coffee or to send a postcard ;-)','Fetch Message');

% Setup the channels in a cell array
switch config.ChannelSet
    case 'BHE,BHN,BHZ'
        channelSet{1} = 'BHE';
        channelSet{2} = 'BHN';
        channelSet{3} = 'BHZ';
    case 'BH1,BH2,BHZ'
        channelSet{1} = 'BH1';
        channelSet{2} = 'BH2';
        channelSet{3} = 'BHZ';
    case 'HHE,HHN,HHZ'
        channelSet{1} = 'HHE';
        channelSet{2} = 'HHN';
        channelSet{3} = 'HHZ';
    case 'HH1,HH2,HHZ'
        channelSet{1} = 'HH1';
        channelSet{2} = 'HH2';
        channelSet{3} = 'HHZ';
    case 'LHE,LHN,LHZ'
        channelSet{1} = 'LHE';
        channelSet{2} = 'LHN';
        channelSet{3} = 'LHZ';
    case 'LH1,LH2,LHZ'
        channelSet{1} = 'LH1';
        channelSet{2} = 'LH2';
        channelSet{3} = 'LHZ';
end

% Get the trace fetching parameters from the global structure
originOffset = sscanf(config.fetchOriginOffset,'%f');  % seconds between start of earthquake and start of requested trace
traceDuration = sscanf(config.fetchDuration,'%f'); % seconds to request from start of trace
outputSampleRate = 1.0/config.requestedSampleRate; % time step to output (in seconds per sample converted from input samples per second)

% Create output time array based on event parameters
outputTimeArray = originOffset:outputSampleRate:traceDuration-outputSampleRate+originOffset;


% init the arrays for the output E,N,Z data
interpolatedAmplitude = zeros(1,length(outputTimeArray));

% A cell array to contain the three-component traces with station and event header info
interpedMergedData = cell(1,3);
rotatedInterpedMergedData = cell(1,3);

% Init Flags
rotateFlag = 0;
interpFlag = 0;

% From the associate auto routine:
select_SKS =~isempty(strmatch('SKS',config.phases));
select_CMT = strcmp(config.catformat,'CMT');
if all([config.calcEnergy, select_CMT, ~select_SKS])
    w=warndlg('SKS is not a selected Phase!! Skipping calculation of SKS-energy');
    waitfor(w)
end

% Prepare a figure window for the traces.
figure('name','Raw trace preview');

% Loop over each event in eq
jevent = 0;
iEventOrig = length(eq);
for ievent = 1:length(eq)
    % User message on progress
    workbar(ievent/length(eq),['Processing files for earthquake ' eq(ievent).dstr] )
    
    % set request start and end times
    originEpochTime = datenum(eq(ievent).date(1),eq(ievent).date(2),eq(ievent).date(3),eq(ievent).date(4),eq(ievent).date(5),eq(ievent).date(6));
    traceStartEpochTime = originEpochTime + (originOffset / 24 / 60 / 60);  % convert from days (matlab's epoch time) to seconds
    traceEndEpochTime = traceStartEpochTime + (traceDuration / 24 / 60 / 60);
    startTimeString = epochTimeToIrisString(traceStartEpochTime);
    endTimeString = epochTimeToIrisString(traceEndEpochTime);

    fprintf('Fetching Event: %s - %s\n',startTimeString, endTimeString);
    
    % init a rotate flag; this MAY vary by event as sometimes stations are
    % re-oriented
    rotateFlag = 0;
        
    % Loop for each channel; 
    for ichannel=1:3
        thisChannel = channelSet{ichannel};
        interpFlag = 0;
        
        % Check for restricted request
        if isempty(config.restrictedAccess{1}) 
            % request only this channel
            dataTraces = irisFetch.Traces(config.netw, config.stnname, config.locid, thisChannel, startTimeString, endTimeString, config.serviceDataCenter,'includePZ');
        else
            dataTraces = irisFetch.Traces(config.netw, config.stnname, config.locid, thisChannel, startTimeString, endTimeString, config.serviceDataCenter,'includePZ',config.restrictedAccess);
        end
        
         ntraces = length(dataTraces);

         if ntraces == 0
             fprintf('No data found for event!\n');
             interpedMergedData = cell(1,3);
             rotatedInterpedMergedData = cell(1,3);
             break
         end
         
         % Check for multiple traces. Indicates multiple location codes or
         % gappy data
         if ntraces > 1
             % if multiple location codes, take the last one. This seems kind
             % of weird, but the test case at ANMO found significantly cleaner
             % data on the 10 location coded channels relative to the 00 location coded channels
         
             % Fill a matrix with dummy location codes
             %locIds = repmat('00',ntraces,1);
             locIds = cell(1,ntraces);
             % Find number of location codes
             for itrace = 1:ntraces
                 locIds{itrace} = sprintf('%02s',dataTraces(itrace).location);
             end
             
             % Make a unique list of locations
             uniqueLocIds = unique(locIds);
             if length(uniqueLocIds) > 1
                 % find only the last one and then put the traces structure
                 % into it
                 jtraces = 1;
                 lastLocId = uniqueLocIds{end};
                 for itrace = 1:length(dataTraces)
                    if strcmp(dataTraces(itrace).location, lastLocId)
                        dataTracesNew(jtraces) = dataTraces(itrace);
                        jtraces = jtraces + 1;
                    end
                 end
             else 
                 dataTracesNew = dataTraces;   % in the event that there is only 1 location code
             end             
           
             % if more than one trace returned, merge
             interpFlag = 0;
             % find number of gappy segments
             if length(dataTracesNew) > 1
                 % Find number of points obtained
                 nptsObtained = 0;
                 for itrace=1:length(dataTracesNew)
                     nptsObtained = nptsObtained + dataTracesNew(itrace).sampleCount;
                 end
                 % preallocate time and amplitude
                 yMergeArray = zeros(1,nptsObtained);
                 xMergeArray = zeros(1,nptsObtained);
                 
                 % Create x and y arrays of time and amplitudes
                 jtrace = 1;
                 for itrace=1:length(dataTracesNew)
                     yMergeArray(jtrace:(jtrace+dataTracesNew(itrace).sampleCount-1)) = dataTracesNew(itrace).data(:)';
                     % find time offset between this trace and the origin
                     % populate the xMergeArray with the time (in seconds)
                     % since the origin
                     traceStartOriginOffsetSeconds = (dataTracesNew(itrace).startTime - originEpochTime) * 24 * 60 * 60;
                     
                     % This method of determining the timing of fetch may
                     % have problems when the sample rate and requested
                     % origin are slightly off.
                     % traceEndOriginOffsetSeconds = (dataTracesNew(itrace).endTime - originEpochTime) * 24 * 60 * 60;
                     % xMergeArray(jtrace:(jtrace+dataTracesNew(itrace).sampleCount-1)) = traceStartOriginOffsetSeconds:1.0/dataTracesNew(itrace).sampleRate:traceEndOriginOffsetSeconds;
                     
                     % More robust for interpolation, but *probably* slower
                     xMergeArray(jtrace) = traceStartOriginOffsetSeconds;
                     for ii=1:dataTracesNew(itrace).sampleCount-1
                         xMergeArray(jtrace+ii) = xMergeArray(jtrace+ii-1) + 1.0/dataTracesNew(itrace).sampleRate;
                     end
                     
                     % update the jtrace - index used to find location
                     % within the merge arrays
                     jtrace = jtrace + dataTracesNew(itrace).sampleCount;
                     
                 end
                 
                 % interp1
                 interpolatedAmplitude = interp1(xMergeArray,yMergeArray,outputTimeArray,'linear','extrap');
                 
                 % set a flag that says its been interpolated
                 interpFlag = 1;
                 
                 % repack the interpolated array into dataTracesMerged
                 dataTracesMerged = dataTracesNew(1);
                 dataTracesMerged.data = zeros(1,length(interpolatedAmplitude));
                 dataTracesMerged.data = interpolatedAmplitude;
                 dataTracesMerged.sampleCount = length(dataTracesMerged.data);
                 dataTracesMerged.sampleRate = config.requestedSampleRate;
                 dataTracesMerged.endTime = traceEndEpochTime;
                 dataTracesMerged.startTime = traceStartEpochTime;
                 
             else
                 dataTracesMerged = dataTracesNew;
             end
             
             
         else
             dataTracesMerged = dataTraces;  % case where we don't merge or find single location code
         end
         
         % resample
         % check interpolation flag and skip if already interpolated or at
         % desired sample rate
         if interpFlag == 0 
             if dataTracesMerged.sampleRate ~= config.requestedSampleRate || (length(dataTracesMerged.data) ~= length(outputTimeArray)) %both in samples per second
                % interp
                % First need the recorded time array
                traceStartOriginOffsetSeconds = (dataTracesMerged.startTime - originEpochTime) * 24 * 60 * 60;
                %traceEndOriginOffsetSeconds = (dataTracesMerged.endTime - originEpochTime) * 24 * 60 * 60;
                %tmpTimeArray = traceStartOriginOffsetSeconds:1.0/dataTracesMerged.sampleRate:traceEndOriginOffsetSeconds;
                tmpTimeArray = ones(1,length(dataTracesMerged.data));
                tmpTimeArray(1) = traceStartOriginOffsetSeconds;
                for ii=2:length(tmpTimeArray)
                    tmpTimeArray(ii) = tmpTimeArray(ii-1) + 1/dataTracesMerged.sampleRate;
                end
                % now call interp1
                interpolatedAmplitude = interp1(tmpTimeArray,dataTracesMerged.data,outputTimeArray,'linear','extrap');
             
                % update the interp flag
                interpFlag = 1;
             
                % update the interped array
                dataTracesMerged.data = zeros(1,length(interpolatedAmplitude));
                dataTracesMerged.data = interpolatedAmplitude;
                dataTracesMerged.sampleCount = length(dataTracesMerged.data);
                dataTracesMerged.sampleRate = config.requestedSampleRate;
                dataTracesMerged.endTime = traceEndEpochTime;
                dataTracesMerged.startTime = traceStartEpochTime;
             
             end
             
         end
         
         % Consider instead storing and checking to rotate to E-N-Z...
        if dataTracesMerged.azimuth ~= 0
            if dataTracesMerged.azimuth ~= 90
                rotateFlag = 1;
            end
        end
        
         % Put the station-channel structured data into a c3ell array which
         % can contain all 3 components
         interpedMergedData{ichannel} = dataTracesMerged;

         % Let user know we're still working
         fprintf('Fetched channel: %s\n',thisChannel);
        
    end  % end channel loop
   
    
    % Response removal on the merged and interpolated data
    % arguably, this should be done with each trace segment before
    % interpolation to a common sample rate. However, it should be
    % sufficient for splitting measurements
    % Also note that we are hard wiring here a low corner period of 200
    % seconds.
    if (~isempty(interpedMergedData{1})) 
        [interpedMergedData,ierror] = SL_responseRemoval( interpedMergedData, 0.005 );
    else
        ierror = 1;
    end
    
    % Kill if dead channel exists
    if ierror == 0
        for itrace = 1:3
            if (max(interpedMergedData{itrace}.data) == min(interpedMergedData{itrace}.data))
                ierror = 1;
            end
        end
    end
    
    % Do rotation if necessary
    if rotateFlag == 1 && ierror == 0
        [interpedMergedData, ierror] = SL_rotateCellTripleToENZ(interpedMergedData);
    end
    
    if ierror == 0 && ~isempty( interpedMergedData{1} )
        
        % write sac files
        [finalTraces, ierror] = SL_writeFetchedTraces(interpedMergedData, eq(ievent));
    
        % Make a quick plot of the 3 component data
        for ichannel=1:3
             tmpArray = finalTraces{ichannel}.data - mean(finalTraces{ichannel}.data);
             subplot(3,1,ichannel)
             plot(outputTimeArray,tmpArray,'-k')
             axis([outputTimeArray(1) outputTimeArray(end) min(tmpArray)*1.05 max(tmpArray)*1.05])
             str=sprintf('%s.%s.%s.%s  %s',finalTraces{ichannel}.network, finalTraces{ichannel}.station,finalTraces{ichannel}.location,finalTraces{ichannel}.channel, eq(ievent).dstr);
             title(str)
             grid on
             grid minor
        end
        drawnow
       
        
        % put sac file name into eq.seisfile
        eq(ievent).seisfiles{1} = finalTraces{1}.sacFileName;
        eq(ievent).seisfiles{2} = finalTraces{2}.sacFileName;
        eq(ievent).seisfiles{3} = finalTraces{3}.sacFileName;

        % Calculate phase arrivals
        eq(ievent).offset(1:3) = originOffset;
        if config.calcphase
            eq(ievent).phase = SL_calcphase(config, eq(ievent));
            if all([config.calcEnergy, select_SKS, select_CMT]) %only SKS-phase
                eq(ievent).energy = SL_calcEnergy(eq(ievent));
            end
        end
            
        % increment the number of events returned
        jevent = jevent + 1;
        
    else
        fprintf('Event data missing\n')
    end    
end % event loop
 
% Sift through events removing the empty ones
new_eq = eq(1:jevent);   % just an init
jevent = 1;
for ievent=1:length(eq)
    if ~strcmp(eq(ievent).seisfiles{1},'')
        new_eq(jevent) = eq(ievent);
        jevent = jevent + 1;
    end
end
eq = new_eq;

str = sprintf('Data fetching complete!\n Obtained waveforms for %d / %d events.\n',length(eq),iEventOrig);
helpdlg(str);
                                                                                    
end





