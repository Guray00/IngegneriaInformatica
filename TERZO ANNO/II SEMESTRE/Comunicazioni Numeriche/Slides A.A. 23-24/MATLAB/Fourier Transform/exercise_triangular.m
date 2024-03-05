clear; close all;
% This script computes the Fourier transform

%% Generate a triangular function of duration T

% Amplitude
A = 1;
% Duration in seconds
T = 0.5;
% Sampling time in seconds
Ts = 0.001;
% Time duration
durT = 10;

%% Generate time-domain waveform
% Time instants
time_samples = -durT:Ts:durT;
% Generate the triangular function
g = zeros(length(time_samples),1);

for ii = 1:length(time_samples)
    
    if -T <= time_samples(ii) && time_samples(ii) <= 0
        
        g(ii) = A + A/T*time_samples(ii);
        
    elseif 0 < time_samples(ii) && time_samples(ii) <= T
        
        g(ii) = A - A/T*time_samples(ii);
        
    end
    
end

figure(1); hold on; box; grid on;
plot(time_samples,g,'-k','LineWidth',2)
xlabel('Time in seconds')
ylabel('Time-domain waveform')
set(gca,'fontsize',18);
ylim([-2 2])
xlim([-2 2])

%% Compute Fourier Transform

% Sampling frequency in Hz
deltaf = 0.01;
% Frequency interval in Hz
durF = 10;

% Fourier Transform (Simulated)
[G, frequency_samples] = function_Fourier_Transform(g, time_samples, Ts, deltaf, durF);

% Fourier Transform (Exact for a triangular function)
G_theo = A*T*sinc(frequency_samples*T).^2;

% Plot of the absolute valued of Fourier transform
figure(2); hold on; box; grid on;
plot(frequency_samples, abs(G),'-k','LineWidth',2)
plot(frequency_samples, abs(G_theo),'-r','LineWidth',2)
legend('Simulated','Exact')
xlabel('Frequency in Hz')
ylabel('Amplitude of Fourier transform')
set(gca,'fontsize',18);
ylim([-1 1])
xlim([-durF durF])



%% Compute Inverse Fourier Transform
% Fourier Transform
[g_inv, time_samples] = function_Inverse_Fourier_Transform(G, ...
    frequency_samples,deltaf, Ts,durT);

figure(1); hold on; box; grid on;
plot(time_samples,real(g_inv),'-r','LineWidth',2)
xlabel('Time in seconds')
ylabel('Time-domain waveform')
set(gca,'fontsize',18);
ylim([-0.5 1.5])
xlim([-2 2])
























