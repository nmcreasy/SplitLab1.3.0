function varargout=SL_read_FetchEvent(catalogue)
% Read a fixed-width file output by FetchEvent perl script
% 
% FetchEvent: collect event information (2013.198)
% http://service.iris.edu/clients/
% 
% Usage: FetchEvent [options]
% 
%  Options:
%  -v                More verbosity, may be specified multiple times (-vv, -vvv)
% 
%  -s starttime      Limit to origins after time (YYYY-MM-DD,HH:MM:SS.sss)
%  -e endtime        Limit to origins before time (YYYY-MM-DD,HH:MM:SS.sss)
%  --lat min:max     Specify a minimum and/or maximum latitude range
%  --lon min:max     Specify a minimum and/or maximum longitude range
%  --radius lat:lon:maxradius[:minradius]
%                      Specify circular region with optional minimum radius
%  --depth min:max   Specify a minimum and/or maximum depth in kilometers
%  --mag min:max     Specify a minimum and/or maximum magnitude
%  --magtype type    Specify a magnitude type for magnitude range limits
%  --cat name        Limit to origins from specific catalog (e.g. ISC, PDE, GCMT)
%  --con name        Limit to origins from specific contributor (e.g. ISC, NEIC)
%  --ua date         Limit to origins updated after date (YYYY-MM-DD,HH:MM:SS)
% 
%  --allorigins      Return all origins, default is only primary origin per event
%  --allmags         Return all magnitudes, default is only primary magnitude per event
%  --orderbymag      Order results by magnitude instead of time
% 
%  --evid id         Select a specific event by DMC event ID
%  --orid id         Select a specific event by DMC origin ID
% 
%  -X xmlfile        Write raw returned XML to xmlfile
%  -A appname        Application/version string for identification
% 
%  -o outfile        Write event information to specified file, default: console
%
% Do NOT request xml format!
% Rob Porritt, July 2014

global config

hbox=questdlg(help('SL_read_FetchEvent'),'SL_read_FetchEvent','Open local file','Cancel','Cancel');
drawnow
switch hbox
    case 'Cancel'
        return
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'Open local file'
        [filename, pathname] = uigetfile( ...
            {'*.dat';'*.txt';'*.csv';'*.*'}, ...
            'Pick the earthquake file');
        
        %  RWP edit for FetchEvent output format:
        %2637599 |2007/09/29 17:25:00.3400|-21.1404| 169.2318|  16.5|ISC|ISC|ISC,12974138|MW,5.7,GCMT|LOYALTY ISLANDS REGION

        if filename==0 & pathname==0
            return
        end
        
        workbar(.4,'Reading data...')

        % Open and scan the file
        fid = fopen(fullfile(pathname,filename),'r');
        if (fid == 0) 
            errordlg('Error, file not found!');
            return
        end
        data = textscan(fid,'%d %s %f %f %f %s %s %s %s %s','Delimiter','|');
        fclose(fid);
        
        % Some of my cmt structure can be loaded instantly:
%         cmt.lat = data{3};
%         cmt.long = data{4};
%         cmt.depth = data{5};
        tmpLatitude = data{3};
        tmpLongitude = data{4};
        tmpDepth = data{5};
         
        % Init the rest:
        nevents = length(data{3});
        cmt.year = zeros(nevents,1);
        cmt.month = zeros(nevents,1);
        cmt.day = zeros(nevents,1);
        cmt.jjj = zeros(nevents,1);
        cmt.hour = zeros(nevents,1);
        cmt.minute = zeros(nevents,1);
        cmt.sec = zeros(nevents,1);
        cmt.Mb = zeros(nevents,1);
        cmt.Mw = zeros(nevents,1);
        cmt.MS = zeros(nevents,1);
        cmt.M0 = zeros(nevents,1);
        cmt.strike = zeros(nevents,1);
        cmt.rake = zeros(nevents,1);
        cmt.dip = zeros(nevents,1);
        cmt.ID = repmat('00000000000000',nevents,1);
        cmt.region = repmat('000000000000000000000000',nevents,1);

        % Timing info prep:
        tmpTimeString=data{2};
        tmpTimeChar=char(tmpTimeString);
        tmpMagnitudeString = data{9};
        tmpMagnitudeChar = char(tmpMagnitudeString);
        tmpIdString = data{1};
        tmpRegionString = data{10};
        tmpRegionChar = char(tmpRegionString);
        
        
        % Loop to fill
        % Values are now initialized. Setup a for loop to fill them
        j=nevents;   % Note that FetchEvents puts the most recent events up top, so this j counts down to reverse the order
        for i=1:nevents
            %fprintf('Working on event %d %s\n%s\n',i,eventsFound(i).PreferredTime,eventsFound(i).PublicId);
            % First break out the timing from preferredTime
            timeVector = sscanf(tmpTimeChar(i,:),'%d/%d/%d %d:%d:%f');
            cmt.year(j) = timeVector(1);
            cmt.month(j) = timeVector(2);
            cmt.day(j) = timeVector(3);
            cmt.jjj(j) = dayofyear(timeVector(1), timeVector(2), timeVector(3));
            cmt.hour(j) = timeVector(4);
            cmt.minute(j) = timeVector(5);
            cmt.sec(j) = timeVector(6);
            cmt.lat(j) = tmpLatitude(i);
            cmt.long(j) = tmpLongitude(i);
            cmt.depth(j) = tmpDepth(i);
            tmpMagnitude = sscanf(tmpMagnitudeChar(i,4:6),'%f');
            cmt.Mb(j) = tmpMagnitude;
            cmt.Mw(j) = tmpMagnitude;
            cmt.MS(j) = tmpMagnitude;
            cmt.M0(j) = tmpMagnitude;
            cmt.ID(j,:) = sprintf('%014d',tmpIdString(i));
            if length(tmpRegionChar(i)) > 24
                iend = 24;
            else
                iend = length(tmpRegionChar(i));
            end
            cmt.region(j,:) = sprintf('%24s',tmpRegionChar(i,1:iend));
            j=j-1;
        end
        
        
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
workbar(.9,'Processing data...')

workbar(1)
drawnow


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% save datebase:
[FileName,PathName] = uiputfile('*.mat','Save Catalogue', 'FetchEventCatalogue.mat');
if ~(FileName==0)
    fname=fullfile(PathName,FileName);
    save(fname,'cmt')
    helpdlg({['File "' fname '" sucsessfully written'],
        ['start: ' datestr( [cmt.year(1), cmt.month(1), cmt.day(1),0,0,0])],
        ['stop:  ' datestr( [cmt.year(end), cmt.month(end), cmt.day(end),0,0,0])],
        ['Mw_min: ' num2str(min(cmt.Mw)) '   Mw_max: ' num2str(max(cmt.Mw))]},...
        'SL_read_FetchEvent sucess')
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

