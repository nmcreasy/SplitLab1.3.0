function [ irisTimeString ] = timeVectorToIrisTimeString( timeVector )
% Converts from a date vector such as used in eq(:).date() to iris's
% 'YYYY-MM-DD HH:MN:SS.SSS'
% Input should have six elements
% Rob Porritt, July 2014
    irisTimeString = sprintf('%04d-%02d-%02d %02d:%02d:%05.3f',timeVector(1),timeVector(2),timeVector(3),timeVector(4),timeVector(5),timeVector(6));
end

