%% function SL_writeFetchedTraces( fetchedTracesCellArray, eqin )
%    Creates format for sl_wsac and then writes new sac files in datadir
%    fills header with info from the cell array and eqin.
% Rob Porritt, July 2014
function [outputTraces, ierr] = SL_writeFetchedTraces( fetchedTracesCellArray, eqin )
global config

%% Prepare sac file name in config.datadir using mseed2sac format such as:
%  YI.D16..LLZ.M.2007,103,05:42:23.SAC
%  NN.SSS.LL.CCC.Q.YYYY,JJJ,HH:MN:SS.SAC
%  Where the timing near the end represents the start time of the trace
%  For the location code (LL), it can often be blank. One method may be to
%  force a value there, but to stay with the convention, we'll leave it
%  blank.
%  Network code (NN) however should not be left blank as that may create
%  hidden files
%  Also note, that we have interpolated and rotated data, so we have to set
%  the proper channel code for each component

%% Error checks - really should NEVER happen if used properly!
% Require 3 component data
if length(fetchedTracesCellArray) ~= 3
    fprintf('Error, SL_writeFetchedTraces given non-three component data!\n');
    ierr = 1;
    return
end

% Require 1 vertical component
ivertical = 0;
nvertical = 0;
for i=1:3
    if fetchedTracesCellArray{i}.dip ~= 0
        ivertical = i;
        nvertical = nvertical + 1;
    end
end
if nvertical ~= 1
    fprintf('Error, SL_writeFetchedTraces given more than or less than 1 vertical channel!\n');
    ierr = 2;
    return
end

%% Build up the channel code
% Lets start by piecing together the channel code
% For the sake of sanity, we're going to assume only velocity instruments
% (middle character H)
% See: http://www.fdsn.org/seed_manual/SEEDManual_V2.4_Appendix-A.pdf
firstChannelChar = 'B';  % default and fits most pre-coded sample rates
if config.requestedSampleRate >= 80
    firstChannelChar = 'H';
elseif config.requestedSampleRate >= 10
    firstChannelChar = 'B';
elseif config.requestedSampleRate == 1
    firstChannelChar = 'L';
elseif config.requestedSampleRate >= 0.1
    firstChannelChar = 'V';
elseif config.requestedSampleRate >= 0.01
    firstChannelChar = 'U';
end  % other channel rates exist, but would be poor choices for most splitting analyses

% here is hard code to high gain broadband
secondChannelChar = 'H';

% stupidly complicated and in most cases redundant, but need to be sure
% that we have the right channel code in the structure
for itrace=1:3
    if fetchedTracesCellArray{itrace}.dip ~= 0
        % vertical
        channelCode = sprintf('%s%sZ',firstChannelChar, secondChannelChar);
        fetchedTracesCellArray{itrace}.channel = channelCode;
    else
        if fetchedTracesCellArray{itrace}.azimuth == 0
            % north
            channelCode = sprintf('%s%sN',firstChannelChar, secondChannelChar);
            fetchedTracesCellArray{itrace}.channel = channelCode;
        else
            %east
            channelCode = sprintf('%s%sE',firstChannelChar, secondChannelChar);
            fetchedTracesCellArray{itrace}.channel = channelCode;
        end
    end
end

%% Force a non-null network code
if strcmp(fetchedTracesCellArray{1}.network,'')
    for i=1:3
        fetchedTracesCellArray{i}.network = sprintf('XX');
    end
end


%% Create the file name for each sac file
tmp = datevec(fetchedTracesCellArray{1}.startTime);  % uses the matlab built-in
jday = dayofyear(tmp(1), tmp(2), tmp(3));    % sub-function included with splitlab
for itrace = 1:3
    % writes the output sac file names in the convention chosen in the
    % findfiles panel
    switch config.FileNameConvention
        case 'RDSEED'
            % RDSEED format '1993.159.23.15.09.7760.IU.KEV..BHN.D.SAC'
            fetchedTracesCellArray{itrace}.sacFileName = sprintf('%04d.%03d.%02d.%02d.%07.4f.%s.%s.%s.%s.%s.SAC',...
                tmp(1), jday, tmp(4), tmp(5), tmp(6),...
                fetchedTracesCellArray{itrace}.network,fetchedTracesCellArray{itrace}.station, fetchedTracesCellArray{itrace}.location,...
                fetchedTracesCellArray{itrace}.channel, fetchedTracesCellArray{itrace}.quality);
        case 'mseed2sac1'
            fetchedTracesCellArray{itrace}.sacFileName = sprintf('%s.%s.%s.%s.%s.%04d,%03d,%02d:%02d:%02.0f.SAC',...
                fetchedTracesCellArray{itrace}.network,fetchedTracesCellArray{itrace}.station, fetchedTracesCellArray{itrace}.location,...
                fetchedTracesCellArray{itrace}.channel, fetchedTracesCellArray{itrace}.quality,...
                tmp(1), jday, tmp(4), tmp(5), tmp(6));

        case 'mseed2sac2'
            fetchedTracesCellArray{itrace}.sacFileName = sprintf('%s.%s.%s.%s.%s.%04d.%03d.%02d%02d%02.0f.SAC',...
                fetchedTracesCellArray{itrace}.network,fetchedTracesCellArray{itrace}.station, fetchedTracesCellArray{itrace}.location,...
                fetchedTracesCellArray{itrace}.channel, fetchedTracesCellArray{itrace}.quality,...
                tmp(1), jday, tmp(4), tmp(5), tmp(6));
        case 'SEISAN'
            % SEISAN format '2003-05-26-0947-20S.HOR___003_HORN__BHZ__SAC'
            fetchedTracesCellArray{itrace}.sacFileName = sprintf('%04d-%02d-%02d-%02d%02d-%02.0fS.%s___%s_%s__%s__SAC',...
                tmp(1), tmp(2),tmp(3), tmp(4), tmp(5), tmp(6),...
                fetchedTracesCellArray{itrace}.network, fetchedTracesCellArray{itrace}.location,...
                fetchedTracesCellArray{itrace}.station, fetchedTracesCellArray{itrace}.channel);
        case 'YYYY.JJJ.hh.mm.ss.stn.sac.e'
            %  Format: 1999.136.15.25.00.ATD.sac.z
            fetchedTracesCellArray{itrace}.sacFileName = sprintf('%04d.%03d.%02d.%02d.%02.0f.%s.sac.%s',tmp(1), jday, tmp(4), tmp(5), tmp(6),...
                fetchedTracesCellArray{itrace}.station, lower(fetchedTracesCellArray{itrace}.channel(end)));
        case 'YYYY.MM.DD-hh.mm.ss.stn.sac.e';
            % Format: 2003.10.07-05.07.15.DALA.sac.z
            fetchedTracesCellArray{itrace}.sacFileName = sprintf('%04d.%02d.%02d-%02d.%02d.%02.0f.%s.sac.%s',tmp(1), tmp(2), tmp(3), tmp(4), tmp(5), tmp(6),...
                fetchedTracesCellArray{itrace}.station, lower(fetchedTracesCellArray{itrace}.channel(end)));
        case 'YYYY_MM_DD_hhmm_stnn.sac.e';
            % Format: 2005_03_02_1155_pptl.sac (LDG/CEA data)
            fetchedTracesCellArray{itrace}.sacFileName = sprintf('%04d_%02d_%02d_%02d%02d_%s.sac.%s',tmp(1), tmp(2), tmp(3), tmp(4), tmp(5),...
                fetchedTracesCellArray{itrace}.station, lower(fetchedTracesCellArray{itrace}.channel(end)));
        case 'stn.YYMMDD.hhmmss.e'
            % Format: fp2.030723.213056.X (BroadBand OBS data)
            fetchedTracesCellArray{itrace}.sacFileName = sprintf('%s.%02d%02d%02d.%02d%02d%02.0f.%s',fetchedTracesCellArray{itrace}.station,...
                tmp(1)-2000,tmp(2),tmp(3),tmp(4),tmp(5),tmp(6),lower(fetchedTracesCellArray{itrace}.channel(end)));
        case '*.e; *.n; *.z'
            % free format - choose mseed2sac1 because RWP likes it best,
            % but append .e, .n, or.z
            fetchedTracesCellArray{itrace}.sacFileName = sprintf('%s.%s.%s.%s.%s.%04d,%03d,%02d:%02d:%02.0f.SAC.%s',...
                fetchedTracesCellArray{itrace}.network,fetchedTracesCellArray{itrace}.station, fetchedTracesCellArray{itrace}.location,...
                fetchedTracesCellArray{itrace}.channel, fetchedTracesCellArray{itrace}.quality,...
                tmp(1), jday, tmp(4), tmp(5), tmp(6),lower(fetchedTracesCellArray{itrace}.channel(end)));
    end
end

% full file name
for itrace = 1:3
   fetchedTracesCellArray{itrace}.fullSacFileName = fullfile(config.datadir, fetchedTracesCellArray{itrace}.sacFileName);
end

% check that datadir exists, and make it if necessary
% note the [~,~] is not an emoji, but is because I don't care about the
% success or message of the command
[~,~] = mkdir(config.datadir);

%% prepare format for sl_wsac.m
%  RWP editorial: I usually use a different library for read/write sac, but
%  here I use the Saclab routines included with splitlab for consistancy.
%  Please feel free to thank me with an AGU beer.
traceBeginTime = 0;  %b
traceEndTime   = 24*60*60*(fetchedTracesCellArray{1}.endTime - fetchedTracesCellArray{1}.startTime); %e
traceOriginTime = traceBeginTime - sscanf(config.fetchOriginOffset,'%f'); %o

% determines the independent variable based on the response decision
switch config.requestedResponseRemoval
    case 'No Removal'
        idep = 5;
    case 'Scalar Only'
        idep = 5;
    case 'Pole-Zero to Displacement'
        idep = 6;
    case 'Pole-Zero to Velocity'
        idep = 7;
    case 'Pole-Zero to Acceleration'
        idep = 8;
end
        

% Fill a generic header that is just updated with relevants for each trace
header = zeros(1,306);
header(1) = 1.0/config.requestedSampleRate;
header(4:5) = -12345;
header(6) = traceBeginTime;
header(7) = traceEndTime;
header(8) = traceOriginTime;
header(9:31) = -12345;
header(32) = fetchedTracesCellArray{1}.latitude;
header(33) = fetchedTracesCellArray{1}.longitude;
header(34) = fetchedTracesCellArray{1}.elevation;
header(35) = fetchedTracesCellArray{1}.depth;
header(36) = eqin.lat;
header(37) = eqin.long;
header(38) = -12345;
header(39) = eqin.depth;
header(40) = eqin.Mw;
header(41:50) = -12345;
header(51) = eqin.dis * 111.19;  % rough conversion from degrees to km
header(52) = eqin.azi;
header(53) = eqin.bazi;
header(54) = eqin.dis;
header(55:56) = -12345;
header(60:70) = -12345;
header(71) = tmp(1); % tmp still contains our timing information from above!
header(72) = jday;
header(73) = tmp(4);
header(74) = tmp(5);
header(75) = floor(tmp(6));
header(76) = roundn(mod(tmp(6),1)  * 1000,1);
header(77) = 6;
header(78:79) = -12345;
header(80) = fetchedTracesCellArray{1}.sampleCount;
header(81:85) = -12345;
header(86) = 1;
header(87) = idep;
header(88) = 9;
header(89:92) = -12345;
header(93) = 77;
header(94) = 45;
header(95) = -12345;
header(96) = 55;
header(97) = 71;
header(98:105) = -12345;
header(106:109) = 1;
header(110) = -12345;
header(111:118) = sprintf('%8s',fetchedTracesCellArray{1}.station);
header(119:134) = sprintf('%16s',eqin.dstr);
header(135:142) = sprintf('%8s',fetchedTracesCellArray{1}.location);
header(143:150) = sprintf('%8s','Origin');
header(151:158) = sprintf('%8s','-12345');
header(159:166) = sprintf('%8s','-12345');
header(167:174) = sprintf('%8s','-12345');
header(175:182) = sprintf('%8s','-12345');
header(183:190) = sprintf('%8s','-12345');
header(191:198) = sprintf('%8s','-12345');
header(199:206) = sprintf('%8s','-12345');
header(207:214) = sprintf('%8s','-12345');
header(215:222) = sprintf('%8s','-12345');
header(223:230) = sprintf('%8s','-12345');
header(231:238) = sprintf('%8s','-12345');
header(239:246) = sprintf('%8s','-12345');
header(247:254) = sprintf('%8s','-12345');
header(255:262) = sprintf('%8s','-12345');
header(263:270) = sprintf('%8s','-12345');
header(279:286) = sprintf('%8s',fetchedTracesCellArray{1}.network);
tmptmp = datevec(now);
jjday = dayofyear(tmptmp(1), tmptmp(2), tmptmp(3));
header(287:294) = sprintf('%04d-%03d',tmptmp(1),jjday);
if length(fetchedTracesCellArray{1}.instrument) < 8
    fetchedTracesCellArray{1}.instrument = sprintf('%8s',fetchedTracesCellArray{1}.instrument);
end
header(295:302) = sprintf('%8s',fetchedTracesCellArray{1}.instrument(1:8));
% add header signature for testing files for SAC format
%---------------------------------------------------------------------------
header(303) = 77;
header(304) = 73;
header(305) = 75;
header(306) = 69;

for itrace=1:3
    header(2) = min(fetchedTracesCellArray{itrace}.data);
    header(3) = max(fetchedTracesCellArray{itrace}.data);
    header(57) = mean(fetchedTracesCellArray{itrace}.data);
    header(58) = fetchedTracesCellArray{itrace}.azimuth;
    header(59) = fetchedTracesCellArray{itrace}.dip+90.0; % apparently, this is dip from horizontal and sac wants inclination from vertical
    header(271:278) = sprintf('%8s',fetchedTracesCellArray{itrace}.channel);
    
    % Now we need a 3 column array; 1st column - time, 2nd column -
    % ampliutde, 3rd column - header
    sacfile = zeros(fetchedTracesCellArray{itrace}.sampleCount,3);
    sacfile(:,1) = 1:fetchedTracesCellArray{itrace}.sampleCount;
    sacfile(:,2) = fetchedTracesCellArray{itrace}.data;
    sacfile(1:306,3) = header(1:306);
    sl_wsac(fetchedTracesCellArray{itrace}.fullSacFileName,sacfile);
    fprintf('Wrote: %s\n',fetchedTracesCellArray{itrace}.sacFileName);
end

%% output
outputTraces = fetchedTracesCellArray;
ierr=0;


end

