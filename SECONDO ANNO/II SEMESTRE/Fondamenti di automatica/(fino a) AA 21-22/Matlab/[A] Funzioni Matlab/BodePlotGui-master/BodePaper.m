function BodePaper(om_lo, om_hi, dB_lo, dB_hi, ph_lo, ph_hi, UseRad)
%BodePaper is Matlab code to generate graph paper for Bode plots.  It generates
%two semilog graphs for making Bode plots.  The top plot is for magnitude, the 
%units on the vertical axis is set to dB.  The bottom plot shows phase.  The 
%units on the phase plot can be radians or degrees, at the discretion of the 
%user.  The default is degrees.
%
%The correct calling syntax is:
%   BodePaper(om_lo, om_hi, dB_lo, dB_hi, ph_lo, ph_hi, UseRad)
%       om_lo   the low end of the frequency scale.  This can be either
%               rad/sec or Hz.  No units are displayed on the graph.
%       om_hi   the high end of the frequency scale.
%       dB_lo   the bottom end of the dB scale.
%       dB_hi   the top end of the dB scale.
%       ph_lo   the bottom end of the phase scale.
%       ph_hi   the top end of the phase scale.
%       UseRad  an optional argument.  If this argument is non-zero the units
%               on the phase plot are radians.  If this argument is left off
%               or set to zero, the units are degrees.
%

%Ensure proper number of arguments
if (nargin~=6)  & (nargin~=7),
    beep;
    disp(' ');
    disp('BodePaper needs six argmuments (or seven)');
    disp('Enter "help BodePaper" for more information');
    disp(' ');
    return
end

if nargin==6   %If there is no 7th argument
    UseRad=0;   % UseRad=0, (i.e., phase units are degrees.)
end

%This next set of lines makes the magnitude graph.
subplot(211);
semilogx(0,0);  %Create a set of axes
axis([om_lo, om_hi, dB_lo, dB_hi])
title('Bode Plot');
ylabel('Magnitude (dB)');
grid

%This next section of code sets ticks every 20 dB.
h=gca;
ytick=dB_lo+20*[0:(dB_hi-dB_lo)/20];
set(h,'YTick',ytick);


%This next set of lines makes the phase graph.
subplot(212);
semilogx(0,0);  %Create a set of axes
axis([om_lo, om_hi, ph_lo, ph_hi])
xlabel('Frequency - log scale');
grid

%Put in ticks on y axis
h=gca;
if UseRad==0,
    %This next section of code sets ticks every 45 degrees.
    ytick=ph_lo+45*[0:(ph_hi-ph_lo)/45];
    set(h,'YTick',ytick);
    ylabel('Phase (degrees)');
else
    %If radians, make ticks every 0.25 radians.
    ytick=ph_lo+(pi/4)*[0:(ph_hi-ph_lo)/(pi/4)];
    set(h,'YTick',ytick);
    %Set the tick labels to be fractions of pi.
    set(h,'YTickLabel',num2str(ytick'/pi));
    ylabel('Phase/\pi   (radians/\pi)');
end