function varargout = SL_CustomCatalogueRead(catalogue)
% SL_CustomCatalogueRead(config.catalogue);
%Save "Custom" earthquake catalogue data to read with Splitlab
%
%This is designed for the Columbia dataset where I was provided with the
%format:
% 2008-04-28 15:57:55.3000 -59.040 335.850 17.1 6.1
% YYYY-MM-DD HH:MM:SS.MSEC LAT     LON     DEP  MAG
%
% This catalogue is very close to the March 2013 NEIC format.
% NEIC Format has been updated to:
% YYYY-MM-DDTHH:MM:SS.MSECZ,lat,lon,dep,mag,junk
% 
% The custom catalogue does not contain fault mechanism
% informations. Full SplitLab functionality is not guaranteed ...
%
%

% Rob Porritt, 5 Feb 2014
global config

hbox=questdlg(help('SL_CustomCatalogueRead'),'Help','Open local file','Cancel','Cancel');
drawnow
switch hbox
    case 'Cancel'
        return

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'Open local file'
        [filename, pathname] = uigetfile( ...
            {'*.dat';'*.txt';'*.csv';'*.*'}, ...
            'Pick the earthquake file');

        workbar(.4,'Reading data...')

        %data = dlmread(fullfile(pathname,filename),' ',0,0);
        fid = fopen(fullfile(pathname,filename));
        if (fid ~= -1) 
            C=textscan(fid,'%d-%d-%d %d:%d:%f %f %f %f %f');
            fclose(fid);
            % initialize structure:
            cmt.year     = double(C{1});
            cmt.month    = double(C{2});
            cmt.day      = double(C{3});
            cmt.jjj      = [];
            cmt.hour     = double(C{4});
            cmt.minute   = double(C{5});
            cmt.sec      = double(C{6});
            cmt.lat      = double(C{7});
            cmt.long     = double(C{8});
            cmt.depth    = double(C{9});
            cmt.M0       = [];
            cmt.Mb       = [];
            cmt.Mw       = double(C{10});
        else
            workbar(1,'Canceled')
            drawnow
            return
        end
end

data(:,1) = C{1};
data(:,2) = C{2};
data(:,3) = C{3};
data(:,4) = C{4};
data(:,5) = C{5};
data(:,6) = C{6};
data(:,7) = C{7};
data(:,8) = C{8};
data(:,9) = C{9};
data(:,10) = C{10};


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
workbar(.9,'Processing data...')

%[h,m,s]=strange2hms(data(:,4)); %CONVERT STRAGE TIME FORMAT TO READIBLE FORMAT


%cmt.year     = [cmt.year;   data(:,1)];
%cmt.month    = [cmt.month;  data(:,2)];
%cmt.day      = [cmt.day;    data(:,3)];
tmp=zeros(1,length(data(:,1)));
for i=1:length(data(:,1))
    tmp(i) = dayofyear(data(i,1),data(i,2),data(i,3));
end
%cmt.jjj      = [cmt.jjj;    dayofyear(data(:,1)',data(:,2)',data(:,3)')]; %julian day
cmt.jjj      = double(tmp');
%for i=1:length(data(:,1))
 %   cmt.ID{i} = sprintf('%014d',i);
%end
cmt.ID = repmat('00000000000000',length(data(:,1)),1);
% cmt.hour     = [cmt.hour;   data(:,4)];
% cmt.minute   = [cmt.minute; data(:,5)];
% cmt.sec      = [cmt.sec;    data(:,6)];
% cmt.lat      = [cmt.lat;    data(:,7)];
% cmt.long     = [cmt.long;   data(:,8)];
% cmt.depth    = [cmt.depth;  data(:,9)];
cmt.M0       = ones(length(tmp),1);
cmt.Mb       = ones(length(tmp),1);
cmt.MS       = ones(length(tmp),1);

cmt.strike   = ones(length(tmp),1);
cmt.rake     = ones(length(tmp),1);
cmt.dip      = ones(length(tmp),1);
cmt.region = repmat('000000000000000000000000',length(data(:,1)),1);

%for i=1:length(data(:,1))
%    cmt.region(i) = sprintf('%24s','neverland');
%end

%cmt.region   = repmat('neverland',length(data(:,1)),1);
% cmt.Mw       = [cmt.Mw;     data(:,10)];
%     cmt.region   = '';
%     cmt.strike   = nan;
%     cmt.dip      = nan;
%     cmt.rake     = nan;
workbar(1)
drawnow

%datestr( [cmt.year(1),   cmt.month(1),   cmt.day(1),  0,0,0])
%tmp = [cmt.year(end), cmt.month(end), cmt.day(end), 0, 0, 0];
%datestr( tmp )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% save datebase:
[FileName,PathName] = uiputfile('*.mat','Save Catalogue', 'CustomCatalogue.mat');
if ~(FileName==0)
    fname=fullfile(PathName,FileName);
    save(fname,'cmt')
    %str1 = sprintf('start: %d/%d/%d',cmt.day(1), cmt.month(1), cmt.year(1));
    %str2 = sprintf('end: %d/%d/%d',cmt.day(end), cmt.month(end), cmt.year(end));
    helpdlg({['File "' fname '" successfully written'],
    %    str1,
    %    str2,
         ['start: ' datestr( [double(cmt.year(1)),   double(cmt.month(1)),   double(cmt.day(1)),  0,0,0])],
         ['stop:  ' datestr( [double(cmt.year(end)), double(cmt.month(end)), double(cmt.day(end)),0,0,0])],
        ['Mw_min: ' num2str(min(cmt.Mw)) '   Mw_max: ' num2str(max(cmt.Mw))]},...
        'SL_CustomRead success')
    config.catalogue = fname;
    
end


if nargout==1
    varargout{1}=cmt;
end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [h,m,s]=strange2hms(dat)
% %converts the "strange" time format of the NEIC catalog to hour minute
% %second format
% H = dat/10000;
% h = floor(H);
% M = (H-h)*100;
% m = floor(M);
% s = (M-m)*100;