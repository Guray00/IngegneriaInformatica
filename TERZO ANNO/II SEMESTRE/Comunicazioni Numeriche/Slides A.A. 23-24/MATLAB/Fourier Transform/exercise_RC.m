clear; close all;
% range of frequencies
fRange = logspace(0,6,1000);
% frequenza di taglio
f_T = 10; 
% Risposta in frequenza
H = 1./(1 +1i * fRange/f_T);

figure; box on; 
plot(fRange/f_T, abs(H),'LineWidth',2);
xlabel('Normalized Frequency, f/f_T')
ylabel('Amplitude of Fourier transform')
ylim([-1 1])
set(gca,'fontsize',18);
grid on;

figure; box on; 
plot(fRange/f_T, rad2deg(angle(H)),'LineWidth',2);
xlabel('Normalized Frequency, f/f_T')
ylabel('Phase of Fourier transform')
ylim([-90 90])
set(gca,'fontsize',18);
grid on;


H_dB = 10*log10(abs(H).^2);

figure; box on; grid on;
semilogx(fRange, H_dB,'LineWidth',2);
xlabel('Frequency')
ylabel('Amplitude of Fourier transform in dB')
set(gca,'fontsize',18);
grid on;


