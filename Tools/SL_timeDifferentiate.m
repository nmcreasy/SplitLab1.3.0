%% function outputTrace = SL_timeDifferentiate( inputTrace )
%  Takes an input trace structure as output from irisFetch.m and computes a
%  derivative in the time domain (d/dt). 
%  diff computes the difference which is between two samples and therefore
%  results in a shortened time series. We don't want that, so after using
%  diff to get the differences, we call interp1 interpolate back onto the original time
%  array.
% Rob Porritt, July 2014

function outputTrace = SL_timeDifferentiate( inputTrace )

% Init
outputTrace = inputTrace;
dt=1.0/inputTrace{1}.sampleRate;

% We'll end with an interpolation back to the original time array
outputTimeArray = inputTrace{1}.startTime*24*60*60:dt:inputTrace{1}.endTime*24*60*60-dt;

% For each of the three components, compute the dy/dt and then interpolate
% back
for icomponent=1:3
    tmpY = diff(outputTrace{icomponent}.data) / dt;
    %tmpX = inputTrace{icomponent}.startTime*24*60*60+(dt/2.0):dt:inputTrace{icomponent}.endTime*24*60*60-(dt/2);
    tmpX = linspace(inputTrace{icomponent}.startTime*24*60*60+(dt/2.0),inputTrace{icomponent}.endTime*24*60*60-(dt/2),length(tmpY));
    outputTrace{icomponent}.data = interp1(tmpX,tmpY,outputTimeArray,'linear','extrap');
end


end

