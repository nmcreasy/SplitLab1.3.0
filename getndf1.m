function [ NDF1 ] = getndf1( S, n, norig )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%n and norig are the same, length of T window and S is the transverse
%component selected window


% A array is assumed to contain a possibly interpolated time series
% of length n.  The length of the original uninterpolated time series
% is NORIG.  ndf_spect computes the effective
% number of degrees of freedom in A, which for a gaussian white noise
% process should be equal to norig.  The true ndf should be less than
% NORIG

% First apply a cosine taper at the ends (taper length 20% of the time window)
tap = fliplr(linspace(0,1,n*0.2))';
A   = S';
A(1:length(tap))         = A(1:length(tap))         .* (cos(tap*pi)+1)/2;
A(end-length(tap)+1:end) = A(end-length(tap)+1:end) .* (cos(fliplr(tap)*pi)+1)/2;

OUT = fft(A);




%%
% calculate the Number of Degrees-Of-Freedom of a summed and squared time
% series with spectrum array A. A is assumed to be a complex function of
% frequency with A[0] corresponding to zero frequency and A[N-1]
% corresponding to the Nyquist frequency.  If A[t] is gaussian distributed
% then ndf_spect should be the points in the original time series 2*(N-1).

mag = abs(OUT);

F2 = sum(mag.^2);
F4 = sum(mag.^4);

F2 = F2-.5*mag(1).^2-.5*mag(end).^2;
F4 = 4/3.*F4-1/3*mag(1).^4-1/3*mag(end).^4;

% based on theory, the following expression should yield
% the correct number of degrees of freedom.(see appendix of silver
% and chan, 1990.  In practise, it gives a value that gives
% a df that is slightly too large.  eg 101 for an original time
% series of 100.  This is due to the fact that their is a slight
% positive bias to the estimate using only the linear term.

NDF1 = round(2*(2*F2*F2/F4 -1) + 0.5);

if NDF1 > norig
    error('get_ndf: NDF > NORIG')
    return
end



end

