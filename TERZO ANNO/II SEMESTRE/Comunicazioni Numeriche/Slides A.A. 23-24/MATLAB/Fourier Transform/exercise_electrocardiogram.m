clear; close all;
% This script computes the Fourier transform
%% Load input signal
load('100m (1).mat');
% Sampling frequency in Hz
fs = 360; Ts = 1/fs;
%Copy data
g = val - mean(val);
%time samples
time_samples = 0:Ts:((length(g)-1)*Ts);

figure(1); hold on; box; grid on;
plot(time_samples,g,'-k','LineWidth',2)
xlabel('Time in seconds')
ylabel('Time-domain waveform')
set(gca,'fontsize',18);


%% Compute Fourier Transform

% Sampling frequency in Hz
deltaf = 0.01;
% Frequency interval in Hz
durF = 100;

% Fourier Transform (Simulated)
[G, frequency_samples] = function_Fourier_Transform(g, time_samples, Ts, deltaf, durF);

% Plot of the absolute valued of Fourier transform 
figure(2); hold on; box; grid on;
plot(frequency_samples, abs(G),'-k','LineWidth',2)
xlabel('Frequency in Hz')
ylabel('Amplitude of Fourier transform')
set(gca,'fontsize',18);
% ylim([-1 1000])
xlim([-durF durF])