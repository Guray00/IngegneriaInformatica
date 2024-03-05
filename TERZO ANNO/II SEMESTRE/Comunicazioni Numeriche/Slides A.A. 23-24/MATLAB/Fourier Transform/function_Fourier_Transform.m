
function [G, frequency_samples] = function_Fourier_Transform(g, time_samples, Ts, deltaf,durF)
%% This function computes the Fourier transform 

% Passare i campioni del segnale come vettore riga, e il campioni del tempo come riga

% Frequency samples
frequency_samples = -durF:deltaf:durF;

%% Implementation using loops
% % Prepare to save Fourier transform samples
% G = zeros(size(frequency_samples));
% 
% %
% % for ii = 1:length(frequency_samples)
% %
% %     for nn = 1:length(time_samples)
% %
% %         arg = 2*pi*frequency_samples(ii)*time_samples(nn);
% %
% %         G(ii) = G(ii) + Ts*g(nn)*exp(-1i*arg);
% %
% %     end
% %
% % end

%% Implementation using matrix-vector operations
% The following operations are needed to ensure that 'time_samples' is a
% row vector and 'g' is a column vector

% Reshape 'time_samples' to obtain a row vector
time_samples = reshape(time_samples,1,[]);
% Reshape 'g' to obtain a column vector
g = reshape(g,[],1);

% Arguments of exponential terms in the Fourier matrix
arg = 2*pi*frequency_samples'*time_samples;
% Fourier matrix
F = exp(-1i*arg);
% Fourier transform 
G= Ts*F*g;