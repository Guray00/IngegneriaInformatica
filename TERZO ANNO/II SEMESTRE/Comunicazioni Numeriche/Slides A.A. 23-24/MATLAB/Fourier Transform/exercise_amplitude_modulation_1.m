clear; close all;
% This script computes the Fourier transform

%% Generate a rectangular function of duration T

% Amplitude
A = 1;
% Duration in seconds
T = 1;
% Sampling time in seconds
Ts = 1e-3;
% Time duration
durT = 1;

%% Generate time-domain waveform
% Time samples in seconds
time_samples = -durT:Ts:durT;
% Prepare to save time-domain samples
g = zeros(size(time_samples));

for k = 1:length(time_samples)
    
    if (-T/2 <= time_samples(k)) && ( time_samples(k) <= T/2)
        
        g(k) = A;
        
    end
       
end

% modulated frequency
f_1 = 50;
% modulator
x_1 = g.*cos(2*pi*f_1*time_samples);

% modulated frequency
f_2 = 100;
% modulator
x_2 = g.*cos(2*pi*f_2*time_samples);

% modulated frequency
f_3 = 30;
% modulator
x_3 = g.*cos(2*pi*f_3*time_samples);

% received signal
x = x_1 + x_2;% + x_3; 

figure(1); hold on; box; grid on;
plot(time_samples,x,'-k','LineWidth',2)
xlabel('Time in seconds')
ylabel('Time-domain waveform')
set(gca,'fontsize',18);
%ylim([-4 4])
xlim([-1 1])

%% Compute Fourier Transform

% Sampling frequency in Hz
deltaf = 0.1;
% Frequency interval in Hz
durF = 200;

% Fourier Transform (Simulated)
[X, frequency_samples] = function_Fourier_Transform(x, time_samples, Ts, deltaf, durF);


% Plot of the absolute valued of Fourier transform 
figure(2); hold on; box; grid on;
plot(frequency_samples, abs(X),'-k','LineWidth',2)
xlabel('Frequency in Hz')
ylabel('Amplitude of Fourier transform')
set(gca,'fontsize',18);
%ylim([-1 1])
xlim([-durF durF])


% Demodulation
x_1_received = 2*x.*cos(2*pi*f_1*time_samples);

% Fourier Transform
[X_1_received, frequency_samples] = function_Fourier_Transform(x_1_received, time_samples, Ts, deltaf, durF);

% Plot of the absolute valued of Fourier transform 
figure(3); hold on; box; grid on;
plot(frequency_samples, abs(X_1_received),'-k','LineWidth',2)
xlabel('Frequency in Hz')
ylabel('Amplitude of Fourier transform')
set(gca,'fontsize',18);
%ylim([-1 1])
xlim([-50 50])


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
