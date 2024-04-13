clear; close all;

d = fdesign.lowpass('Fp,Fst,Ap,Ast',1, 3, 1, 60, 100);
%f = design(d, 'equiripple');  % Design an FIR equiripple filter
f = design(d, 'cheby1');  % Design an FIR equiripple filter
%f = design(d, 'butter');  % Design an FIR equiripple filter
%f = design(d, 'ellip');  % Design an FIR equiripple filter

% % Other designs can be performed for the same specifications
% % designmethods(d,'iir'); % List the available IIR design methods
% f = design(d, 'ellip');  % Design an elliptic IIR filter (SOS).

info(f)                 % View information about filter
fvtool(f)               % visualize various filter responses
input = 10 + randn(10000,1);
output = filter(f,input); % Process data through the elliptic filter.

figure; hold on;
plot(input,'-k','LineWidth',2)
plot(output,'-r','LineWidth',2)

% %% Example of highpass filter
% d  = fdesign.highpass('Fst,Fp,Ast,Ap',0.31,0.32,1e-3,1e-2,'linear');
% Hd = design(d, 'equiripple');
% fvtool(Hd)