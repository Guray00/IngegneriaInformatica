function [g, time_samples] = function_Inverse_Fourier_Transform(G, ...
    frequency_samples,deltaf, Ts,durT)

% Time samples
time_samples = -durT:Ts:durT;

%% Implementation using matrix-vector operations
% The following operations are needed to ensure that 'frequency_samples' is a
% row vector and 'G' is a column vector

% Reshape 'time_samples' to obtain a row vector
frequency_samples = reshape(frequency_samples,1,[]);
% Reshape 'g' to obtain a column vector
G = reshape(G,[],1);

% Arguments of exponential terms in the Fourier matrix
arg = 2*pi*frequency_samples'*time_samples;
% Fourier matrix
F = exp(-1i*arg);
% Fourier transform
g = deltaf*F'*G;