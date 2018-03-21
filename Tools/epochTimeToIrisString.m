function [TimeString] = epochTimeToIrisString(epochTime)
% Convert from an epoch time to a irisFetch style time string
% Rob Porritt, July 2014
    TimeString = datestr(epochTime,'yyyy-mm-dd HH:MM:SS.FFF');
end

