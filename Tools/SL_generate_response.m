%%function responseSpectrum = SL_generate_response(sacpz, lowFreqFloor)
% Generates the complex spectrum based on the input pole zero definition
% from irisFetch.m
% sacpz is a structure with elements:
%       units: 'M'
%    constant: 2.3765e+18
%       poles: [5x1 double]
%       zeros: [3x1 double]
% freqArray defines the series of frequency at which to compute the
% response values
% lowFreqFloor is a frequency (Hertz) at which we assume lower frequencies
% are constant re and im components.
% 
% Unfortunately I doubt there are many easy shortcuts to make this routine
% 'fast'
% Rob Porritt, July 2014

function responseSpectrum = SL_generate_response(sacpz, freqArray, lowFreqFloor)
    
    responseSpectrum = zeros(1,length(freqArray));
    constant = sacpz.constant;
    
    for ifreq = 1:length(freqArray)
        if freqArray(ifreq) >= lowFreqFloor
            freq = freqArray(ifreq) * 2 * pi;
            omega = 0 + freq *1i;
            denom = 1+1*1i;
            num = 1+1*1i;
            % Take care of zeros
            for izero=1:length(sacpz.zeros)
                temp = omega - sacpz.zeros(izero);
                num=num*temp;
            end
            % Deal with poles
            for ipole=1:length(sacpz.poles)
                temp=omega - sacpz.poles(ipole);
                denom = denom * temp;
            end
            % apply constant
            temp = real(denom) - imag(denom) * 1i;
            temp = temp * num;
            mod_squared = real(denom) * real(denom) + imag(denom) * imag(denom);
            temp = real(temp) / mod_squared + (imag(temp) / mod_squared) * 1i;
            responseSpectrum(ifreq) = constant * real(temp) + constant * imag(temp) * 1i;
        
        else  % Case where we are at lower frequency than the floor
            freq = lowFreqFloor * 2 * pi;
            omega = 0 + freq *1i;
            denom = 1+1*1i;
            num = 1+1*1i;
            % Take care of zeros
            for izero=1:length(sacpz.zeros)
                temp = omega - sacpz.zeros(izero);
                num=num*temp;
            end
            % Deal with poles
            for ipole=1:length(sacpz.poles)
                temp=omega - sacpz.poles(ipole);
                denom = denom * temp;
            end
            % apply constant
            temp = real(denom) - imag(denom) * 1i;
            temp = temp * num;
            mod_squared = real(denom) * real(denom) + imag(denom) * imag(denom);
            temp = real(temp) / mod_squared + (imag(temp) / mod_squared) * 1i;
            responseSpectrum(ifreq) = constant * real(temp) + constant * imag(temp) * 1i;     
        end
    end

end

