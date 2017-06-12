function [h]  = rdp(h_unc, toa)

% This function removes the direct path propagation of 
% room impulse responses generated by image method
%
%   [h, dl]  = rdp(h_unc, tau, stat)
%
%	Input Parameters:
%       h_unc   : original room impulse responses
%       toa     : shortest direct-path propagation time in
%                 (fractional) samples
%
%	Output Parameters:
%       h       : updates room impulse responses
%
% Author : E.A.P. Habets
%
% History: 2009-07-11 Initial version by E.A.P. Habets
%          2010-10-16 Automatically selects the microphone that is
%                     closest to the source.
%          2011-03-01 RIRs are now padded with zeros.
%
% Copyright (C) Imperial College London 2009-2011
% Version: $Id: rdp.m 425 2011-08-12 09:15:01Z mrt102 $

[L,M] = size(h_unc);

h_tmp = zeros(L+ceil(toa),M);
for m = 1:M
    h_tmp(:,m) = [h_unc(:, m); h_unc(end, m).*zeros(ceil(toa), 1)];
end

NFFT = 2^nextpow2(size(h_tmp,1));
f = (0:fix(NFFT/2))/NFFT;
H_unc = fft(h_tmp,NFFT);
H = zeros(NFFT,M);
for mm = 1:M    
    E = exp(1i*2*pi*f*toa);
    H(:,mm) = H_unc(:,mm) .* [E conj(E(end-1:-1:2))].';
end
h = real(ifft(H));
h = h(1:L,:);