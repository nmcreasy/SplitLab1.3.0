function SL_fetchStationCoordinates
%% Function to get the latitude and longitude of a station as a call back in spliatlab
%  relies on and writes to the global config variable
%  Does not deal with having multiple matching stations! Just returns the
%  first one.
%  Rob Porritt, July 2014
global config

% Get the handles to the edit boxes
longitudeBoxHandles = findobj('Style','Edit','ToolTipString','Longitude');
latitudeBoxHandles = findobj('Style','Edit','ToolTipString','Latitude');

% Get location params
stas = irisFetch.Stations('STATION',config.netw,config.stnname,config.locid,'*'); % stars for channels
if length(stas) > 0
    config.slat = stas(1).Latitude;
    config.slong = stas(1).Longitude;
    config.elev = stas(1).Elevation;
else
    str = sprintf('Warning, coordinates for station: %s not found! Please input manually or change your data center in the Fetch Traces panel.',config.stnname);
    helpdlg(str);
end


% set edit boxes
set(longitudeBoxHandles,'String',config.slong);
set(latitudeBoxHandles,'String',config.slat);




