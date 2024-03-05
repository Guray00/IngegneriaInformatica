function [G_FFT, frequency_samples_FFT] = function_FFT(g, Ts, deltaf)

% FFT dimension (power of 2)
N_FFT = 2^nextpow2(1/(deltaf*Ts));

% Recomputing deltaf
deltaf = 1/(N_FFT*Ts);

% % FFT transform (remember Ts to approximate the Fourier transform)
% G_FFT = Ts*fft(g,N_FFT);
% 
% % frequency samples of the FFT
% frequency_samples_FFT = 0:deltaf:(1/Ts - deltaf);
% 

%% With fftshift
% FFT transform (remember Ts to approximate the Fourier transform)
G_FFT = Ts*fftshift(fft(g,N_FFT));

% frequency samples of the FFT
frequency_samples_FFT = (-1/(2*Ts)+deltaf):deltaf:(1/(2*Ts));