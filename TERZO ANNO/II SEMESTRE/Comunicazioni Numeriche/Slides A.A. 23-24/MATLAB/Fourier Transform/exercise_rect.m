%clear; close all;
% This script computes the Fourier transform of a rectangular function

%% Generate a rectangular function of duration T

% Amplitude
A = 1;
% Duration in seconds
T = 1;
% Sampling time in seconds
Ts = 0.001;
% Time duration
durT = 10;

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

figure(1); hold on; box; grid on;
plot(time_samples,g,'-k','LineWidth',2)
xlabel('Time in seconds')
ylabel('Time-domain waveform')
set(gca,'fontsize',18);
ylim([-2 2])
xlim([-2 2])

%% Compute Fourier Transform

% Sampling frequency in Hz
deltaf = 0.1;
% Frequency interval in Hz
durF = 10;

% Fourier Transform (Simulated)
% Passare i campioni come vettore riga, e il vettore tempo come riga
[G, frequency_samples] = function_Fourier_Transform(g, time_samples, Ts, deltaf, durF);

% Fourier Transform (Exact for a rectangular function)
G_theo = A*T*sinc(frequency_samples*T);

% Plot of the absolute valued of Fourier transform 
figure(2); hold on; box; grid on;
plot(frequency_samples, abs(G),'-k','LineWidth',2)
plot(frequency_samples, abs(G_theo),'-r','LineWidth',2)
legend('Simulated','Exact')
xlabel('Frequency in Hz')
ylabel('Amplitude of Fourier transform')
set(gca,'fontsize',18);
ylim([-0.5 1.5])
xlim([-durF durF])

% [G_FFT, frequency_samples_FFT] = function_FFT(g, Ts, deltaf);
% 
% % Plot of the absolute valued of Fourier transform 
% figure(2); hold on; box; grid on;
% plot(frequency_samples_FFT, abs(G_FFT),'-g','LineWidth',2)
% legend('Simulated','Theorical','FFT')
% ylim([-0.5 1.5])
% xlim([-10 10])

%% Compute Inverse Fourier Transform
% Fourier Transform
[g_inv, time_samples] = function_Inverse_Fourier_Transform(G, ...
    frequency_samples,deltaf, Ts,durT);

figure(1); hold on; box; grid on;
plot(time_samples,real(g_inv),'--r','LineWidth',2)
xlabel('Time in seconds')
ylabel('Time-domain waveform')
set(gca,'fontsize',18);
ylim([-0.5 1.5])
xlim([-2 2])
%     
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
