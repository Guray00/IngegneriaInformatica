function BodeMagPaper(om_lo, om_hi, dB_lo, dB_hi)
%BodePaper is Matlab code to generate graph paper for Bode plots.  It generates
%a semilog graphs for making Bode plots of magnitude with the 
%units on the vertical axis is set to dB.
%
%Correct calling syntax is:
%   BodeMagPaper(om_lo, om_hi, dB_lo, dB_hi)
%       om_lo   the low end of the frequency scale.  This can be either
%               rad/sec or Hz.  No units are displayed on the graph.
%       om_hi   the high end of the frequency scale.
%       dB_lo   the bottom end of the dB scale.
%       dB_hi   the top end of the dB scale.
%

%Ensure proper number of arguments
if (nargin~=4),
    beep;
    disp(' ');
    disp('BodeMagPaper needs four argmuments)');
    disp('Enter "help BodeMagPaper" for more information');
    disp(' ');
    return
end


%This next set of lines makes the magnitude graph.
subplot(211);
semilogx(0,0);  %Create a set of axes
axis([om_lo, om_hi, dB_lo, dB_hi])
title('Bode Plot Magnitude (Axes 1)');
ylabel('Magnitude (dB)');
grid

%This next section of code sets ticks every 20 dB.
h=gca;
ytick=dB_lo+20*[0:(dB_hi-dB_lo)/20];
set(h,'YTick',ytick);


%This next set of lines makes the phase graph.
subplot(212);
semilogx(0,0);  %Create a set of axes
axis([om_lo, om_hi, dB_lo, dB_hi])
title('Bode Plot Magnitude (Axes 2 - in case of error with Axes 1)');
ylabel('Magnitude (dB)');
grid

%This next section of code sets ticks every 20 dB.
h=gca;
ytick=dB_lo+20*[0:(dB_hi-dB_lo)/20];
set(h,'YTick',ytick);
