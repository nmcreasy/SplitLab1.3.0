function [ outputEpochTime ] = irisTimeStringToEpoch( timeString )
%Function to convert from the iris time string of 'YYYY-MM-DD HH:MM:SS' to
%epoch time
% Use sscanf to get components from time string.
% Rob Porritt, July 2014
  times = sscanf(timeString,'%4d-%2d-%2d %2d:%2d:%f');
  outputEpochTime = datenum(times(1),times(2),times(3),times(4),times(5),times(6));
  
end

