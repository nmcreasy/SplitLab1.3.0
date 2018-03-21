%% function windowedData = SL_applyHannTaper(inputData, halfPercentOfTrace)
%  Applies a symmetric Hann taper on the two sides of the vector data
% Rob Porritt, July 2014

function windowedData = SL_applyHannTaper(inputData, halfPercentOfTrace)

if halfPercentOfTrace > 50
    halfPercentOfTrace = 50;
end

windowedData = inputData;

f0 = 0.5;
f1 = 0.5;
omega = pi / (length(inputData) * halfPercentOfTrace/100);

windowLength = round(length(inputData) * halfPercentOfTrace/100);

% front
for iwin=1:windowLength
    windowedData(iwin) = inputData(iwin) * (f0 - f1 * cos(omega*(iwin-1)));
end

% back
for iwin=length(inputData)-windowLength:length(inputData)
    windowedData(iwin) = inputData(iwin) * (f0 - f1 * cos(omega*(iwin-1)));
end




end