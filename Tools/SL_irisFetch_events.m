function varargout=SL_irisFetch_events(catalogue)
% Calls irisFetch.m to obtain event information
% call irisFetch.m creates a request with the appropriate parameters
%  to create a variable and a .mat file with the event params

% Rob Porritt July 2014;
% built off SL_neic2mat base

global config

hbox=questdlg(help('SL_irisFetch_events'),'Help','Call irisFetch.m','Cancel','Cancel');
drawnow
switch hbox
    case 'Cancel'
        return
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'Goto Server'
        try
            web http://service.iris.edu/fdsnws/event/docs/1/builder/ -browser
        catch
            error('Problems while opening web browser. See <a href="matlab:doc docopt">docopt</a> and <a href="matlab:doc web">web</a> for details')
        end
        return

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'Open local file'
        [filename, pathname] = uigetfile( ...
            {'*.mat'}, ...
            'Pick the earthquake file');
        
        workbar(.4,'Reading data...')
        load(fullfile(pathname,filename));
        % file loaded is already in the necessary structure
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    case 'Call irisFetch.m'
        workbar(0.05,'Sending fetch command to service.iris.edu/...')
        drawnow
        % very simple call to irisFetch.Events. Limiting to M6 and above as
        % it will get exceedingly slow to go to smaller magnitudes. SL_eqwindow
        % follows this call to window out the desired eq parameters. Adjust
        % this call at your own risk.
        eventsFound = irisFetch.Events('MinimumMagnitude',6,'startTime','1976-01-01 00:00:00');
        
        % Now instead of loading an existing catalogue, I need to write a
        % new one. First init the structure components
        cmt.year = zeros(length(eventsFound),1);
        cmt.month = zeros(length(eventsFound),1);
        cmt.day = zeros(length(eventsFound),1);
        cmt.jjj = zeros(length(eventsFound),1);
        cmt.hour = zeros(length(eventsFound),1);
        cmt.minute = zeros(length(eventsFound),1);
        cmt.sec = zeros(length(eventsFound),1);
        cmt.lat = zeros(length(eventsFound),1);
        cmt.long = zeros(length(eventsFound),1);
        cmt.depth = zeros(length(eventsFound),1);
        cmt.Mb = zeros(length(eventsFound),1);
        cmt.Mw = zeros(length(eventsFound),1);
        cmt.MS = zeros(length(eventsFound),1);
        cmt.M0 = zeros(length(eventsFound),1);
        cmt.strike = zeros(length(eventsFound),1);
        cmt.rake = zeros(length(eventsFound),1);
        cmt.dip = zeros(length(eventsFound),1);
        cmt.ID = repmat('00000000000000',length(eventsFound),1);
        cmt.region = repmat('000000000000000000000000',length(eventsFound),1);

        % Values are now initialized. Setup a for loop to fill them
        j=length(eventsFound);
        for i=1:length(eventsFound)
            %fprintf('Working on event %d %s\n%s\n',i,eventsFound(i).PreferredTime,eventsFound(i).PublicId);
            % First break out the timing from preferredTime
            timeVector = sscanf(eventsFound(i).PreferredTime,'%4d-%2d-%2d %2d:%2d:%f');
            cmt.year(j) = timeVector(1);
            cmt.month(j) = timeVector(2);
            cmt.day(j) = timeVector(3);
            cmt.jjj(j) = dayofyear(timeVector(1), timeVector(2), timeVector(3));
            cmt.hour(j) = timeVector(4);
            cmt.minute(j) = timeVector(5);
            cmt.sec(j) = timeVector(6);
            cmt.lat(j) = eventsFound(i).PreferredLatitude;
            cmt.long(j) = eventsFound(i).PreferredLongitude;
            cmt.depth(j) = eventsFound(i).PreferredDepth;  % Note this is in km where as the sac standard is in meters
            cmt.Mb(j) = eventsFound(i).PreferredMagnitude.Value;
            cmt.Mw(j) = eventsFound(i).PreferredMagnitude.Value;
            cmt.MS(j) = eventsFound(i).PreferredMagnitude.Value;
            cmt.M0(j) = eventsFound(i).PreferredMagnitude.Value;
            sep=strfind(eventsFound(i).PublicId,'=');
            cmt.ID(j,:) = sprintf('%14s',eventsFound(i).PublicId((sep+1):end));
            if length(eventsFound(i).FlinnEngdahlRegionName) > 24
                iend = 24;
            else
                iend = length(eventsFound(i).FlinnEngdahlRegionName);
            end
            cmt.region(j,:) = sprintf('%24s',eventsFound(i).FlinnEngdahlRegionName(1:iend));
            j=j-1;
        end
        
        
            
            
            
        
        

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     case 'Update from Server'
%         workbar(.05,'Sending querry to http://neic.usgs.gov/...')
%         drawnow
% 
%         load(catalogue)
%         lastdate = [cmt.year(end) cmt.month(end) cmt.day(end)];
%         lastdate = datevec(datenum(lastdate)+1);% add one day to last date
%         today    = datevec(now);
% 
%         workbar(.2,'Sending query to http://neic.usgs.gov/...')
%         
%         try
%             neic     = urlread(['http://neic.usgs.gov/cgi-bin/epic/epic.cgi'...
%                 '?SEARCHMETHOD=1&FILEFORMAT=6&SEARCHRANGE=HH&SUBMIT=Submit+Search'...
%                 ['&SYEAR=' num2str(lastdate(1)) '&SMONTH=' num2str(lastdate(2)) '&SDAY=' num2str(lastdate(3))]...
%                 ['&EYEAR=' num2str(today(1))    '&EMONTH=' num2str(today(2))    '&EDAY=' num2str(today(3))]...
%                 '&LMAG=4&UMAG=9.9'...
%                 '&NDEP1=0&NDEP2=1000'...
%                 '&IO1=&IO2=&SLAT2=0.0&SLAT1=0.0&SLON2=0.0&SLON1=0.0&CLAT=0.0&CLON=0.0&CRAD=0']);
%         catch
%             workbar(1)
%             errordlg({'Sorry, but I have problems reading the file on the server','http://neic.usgs.gov/cgi-bin/epic/epic.cgi'},'Connection Problems')
%             return
%         end
%         workbar(.7,'Processing data...')
%         start = strfind(neic,'Year');
%         stop  = strfind(neic,'</PRE>') - 2;
%         neic  = neic(start:stop);
%         tmpfile   = tempname;
%         fid = fopen(tmpfile,'w');
%         fprintf(fid,'%s',neic);
%         fclose(fid);
% 
%         data = dlmread(tmpfile,',',1,0);%skip header line
%         delete(tmpfile)
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
workbar(.9,'Processing data...')

%[h,m,s]=strange2hms(data(:,4)); %CONVERT STRAGE TIME FORMAT TO READIBLE FORMAT


% cmt.year     = [cmt.year;   data(:,1)];
% cmt.month    = [cmt.month;  data(:,2)];
% cmt.day      = [cmt.day;    data(:,3)];
% cmt.jjj      = [cmt.jjj;    dayofyear(data(:,1)',data(:,2)',data(:,3)')']; %julian day
% cmt.hour     = [cmt.hour;   h];
% cmt.minute   = [cmt.minute; m];
% cmt.sec      = [cmt.sec;    s];
% cmt.lat      = [cmt.lat;    data(:,5)];
% cmt.long     = [cmt.long;   data(:,6)];
% cmt.depth    = [cmt.depth;  data(:,8)];
% cmt.M0       = nan;
% cmt.Mw       = [cmt.Mw;     data(:,7)];
%     cmt.region   = '';
%     cmt.strike   = nan;
%     cmt.dip      = nan;
%     cmt.rake     = nan;
workbar(1)
drawnow


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% save datebase:
[FileName,PathName] = uiputfile('*.mat','Save Catalogue', 'irisFetchCatalogue.mat');
if ~(FileName==0)
    fname=fullfile(PathName,FileName);
    save(fname,'cmt')
    helpdlg({['File "' fname '" sucsessfully written'],
        ['start: ' datestr( [cmt.year(1), cmt.month(1), cmt.day(1),0,0,0])],
        ['stop:  ' datestr( [cmt.year(end), cmt.month(end), cmt.day(end),0,0,0])],
        ['Mw_min: ' num2str(min(cmt.Mw)) '   Mw_max: ' num2str(max(cmt.Mw))]},...
        'SL_irisFetch_events_read sucess')
    config.catalogue = fname;
end


if nargout==1
    varargout{1}=cmt;
end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [h,m,s]=strange2hms(dat)
%converts the "strange" time format of the NEIC catalog to hour minute
%second format
H = dat/10000;
h = floor(H);
M = (H-h)*100;
m = floor(M);
s = (M-m)*100;

