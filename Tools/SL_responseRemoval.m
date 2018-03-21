%% function [DeconnedTrace, ierr] = SL_responseRemoval( inputTrace, lowFreqFloor )
%  based on the configuration setting in the global config structure,
%  performs an instrument response removal of the input trace
%  Rather than do a full bandpass filter (which you should do later!) this
%  will simply set a floor at lowFreqFloor (frequency, in Hertz) such that
%  all frequency domain amplitudes are at the value of that floor
% Rob Porritt, July 2014

function [DeconnedTrace, ierr] = SL_responseRemoval( inputTrace, lowFreqFloor )
global config

    
% setup inits
DeconnedTrace = inputTrace;
ierr=0;

% check for 3 components
if length(DeconnedTrace) ~= 3
    fprintf('SL_responseRemoval error. Need 3 component data!\n');
    ierr=1;
    return
end

    
% Case: no removal - really this should be the best for 99% of all SKS
% splitting!
if strcmp(config.requestedResponseRemoval,'No Removal')
    return
end

% Simply removing the scalar
% This is per the example at http://www.iris.edu/dms/nodes/dmc/manuals/irisfetchm/
if strcmp(config.requestedResponseRemoval,'Scalar Only')
    if abs(DeconnedTrace{1}.sensitivity) > 0.0 
        DeconnedTrace{1}.data = DeconnedTrace{1}.data / DeconnedTrace{1}.sensitivity;
    end
    if abs(DeconnedTrace{2}.sensitivity) > 0.0 
        DeconnedTrace{2}.data = DeconnedTrace{2}.data / DeconnedTrace{2}.sensitivity;
    end
    if abs(DeconnedTrace{3}.sensitivity) > 0.0
        DeconnedTrace{3}.data = DeconnedTrace{3}.data / DeconnedTrace{3}.sensitivity;
    end
    return
end


% Loop over components
for itrace=1:3
    
    % Because we will do an fft, we need to remove the mean, a linear
    % trend, and apply a hanning taper
    DeconnedTrace{itrace}.data = detrend(DeconnedTrace{itrace}.data);
    DeconnedTrace{itrace}.data = SL_applyHannTaper(DeconnedTrace{itrace}.data,5);
    

    % Case to remove the pole-zero. We will always remove to displacement
    % (given by the 'includePZ' and the sacpz structure). If the user requested
    % velocity we differentiate once. If acceleration is requested, then we
    % differentiate again.
 
    % FFT the data
    dataSpectrum = fft(DeconnedTrace{itrace}.data);

    % Array of frequencies at which to calculate the response
    nptsSpectrum = length(dataSpectrum);
    denom = DeconnedTrace{itrace}.sampleRate * DeconnedTrace{itrace}.sampleCount;
    freqArray=(1:nptsSpectrum)/denom;

    % Generate a response spectrum
    responseSpectrum = SL_generate_response(DeconnedTrace{itrace}.sacpz, freqArray, lowFreqFloor);

    % Seems like the spectrums are being thrown into random orders!
    if (size(dataSpectrum) ~= size(responseSpectrum))
        dataSpectrum = dataSpectrum';
    end
    
    % Data(omega) / response(w)
    deconnedSpectrum = dataSpectrum ./ responseSpectrum;

    % IFFT (symmetric)
    DeconnedTrace{itrace}.data = ifft(deconnedSpectrum,'symmetric');
    
    % % Check for need to do differentiations
    if strcmp(config.requestedResponseRemoval,'Pole-Zero to Velocity')
    %   % one differentiation
        DeconnnedTrace = SL_timeDifferentiate( DeconnedTrace );
    elseif strcmp(config.requestedResponseRemoval, 'Pole-Zero to Acceleration')
    %   % two differentations
        DeconnedTrace = SL_timeDifferentiate( DeconnedTrace );
        DeconnedTrace = SL_timeDifferentiate( DeconnedTrace );
    end
end

end

