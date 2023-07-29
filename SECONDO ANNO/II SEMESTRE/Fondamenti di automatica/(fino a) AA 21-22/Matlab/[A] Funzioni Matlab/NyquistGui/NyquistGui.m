
function varargout = NyquistGui(varargin)
% Doesn't handle multiple poles on axes (except at origin).
% Rounds to nearest 0.001 (if near origin or axis
%
% NYQUISTGUI MATLAB code for NyquistGui.fig
%      NYQUISTGUI, by itself, creates a new NYQUISTGUI or raises the existing
%      singleton*.
%
%      H = NYQUISTGUI returns the handle to a new NYQUISTGUI or the handle to
%      the existing singleton*.
%
%      NYQUISTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NYQUISTGUI.M with the given input arguments.
%
%      NYQUISTGUI('Property','Value',...) creates a new NYQUISTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NyquistGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NyquistGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NyquistGui

% Last Modified by GUIDE v2.5 10-Oct-2011 17:58:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @NyquistGui_OpeningFcn, ...
    'gui_OutputFcn',  @NyquistGui_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before NyquistGui is made visible.
function NyquistGui_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NyquistGui (see VARARGIN)

% Choose default command line output for NyquistGui
handles.output = hObject;

handles.axNumLim=10;    %limit for axes
handles.axDelt=2;       %spacing on grid
handles.axInf=12;       %"Infinity" on graphs
handles.circRad=5;      %radius of circle for plot
set(handles.pauseTButton,'Value',0);
set(handles.pauseTButton,'String','Pause');
handles.tf=[]; dispTF(handles);         %Clear TF
handles.BItfs=[];
handles.nth=32;         %number of points for circular s-domain plot
set(handles.pathDrawPanel,'Visible','off'); %Disable plotting
set(handles.expPanel,'Visible','off');

set(handles.zoomButton,'String','Zoom out');

initSysLists(handles);     % Initialize lists of systems

handles=guidata(hObject);  % Reload handles (changed in getTFInfor)
guidata(hObject, handles); % Update handles structure

initAxes(handles);

% UIWAIT makes NyquistGui wait for user response (see UIRESUME)
% uiwait(handles.NyqGuiFig);


% --- Outputs from this function are returned to the command line.
function varargout = NyquistGui_OutputFcn(~, ~, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function initAxes(handles)
myGrid(handles.sDomAx, handles);  %Initialize axes
axes(handles.sDomAx);
title('s-domain plot (w/ poles and zeros of L(s))');
ylabel('imag(s)');  xlabel('real(s)');

myGrid(handles.ghDomAx, handles);  %Initialize axes
ylabel('imag( L(s) )');  xlabel('real( L(s) )');
if get(handles.NyqPathRButt,'Value'),
    title('L(s)-domain plot (w/ the point -1 shown)); L(s)=G(s)H(s)');
    text(-1,0,'+','HorizontalAlignment','Center',...
        'FontSize',14,'FontWeight','demi');
    thet=linspace(0,2*pi,32);
    plot(cos(thet),sin(thet),':','Color',0.8*[1 1 1]);
else
    title('L(s)-domain plot');
end

% --- Initialize graph
function myGrid(myAx, handles)
axes(myAx);
lm=handles.axNumLim;        %limit for axes
delt=handles.axDelt;        %spacing on grid
lmi=handles.axInf;          %"infinity"
g=0.8*[1 1 1];              %Color for grid.
cla;
set(gca,'XLim',[-lmi lmi]); set(gca,'YLim',[-lmi lmi]);
set(gca,'XTick',-lmi:delt:lmi);
set(gca,'XTickLabel',{'-inf';-lm:delt:lm;'+inf'});
set(gca,'YTick',-lmi:delt:lmi);
set(gca,'YTickLabel',{'-inf';-lm:delt:lm;'+inf'}); box on;
hold on;
thet = 0:0.01:2*pi;
x=lmi*cos(thet); y=lmi*sin(thet); %patch(x,y,'w');
patch([x lmi lmi -lmi -lmi lmi],[y -lmi lmi lmi -lmi -lmi],...
    g+0.5*(1-g),'EdgeColor',g);
plot(lm*sin(thet),lm*cos(thet),':','Color',g);
for x=delt:delt:lm,  % Make grid
    isct=sqrt(lm*lm-x*x); %intersect of line an circle
    plot([x x],[-isct isct],':','Color',g);
    plot([-isct isct],[-x -x],':','Color',g);
    plot([-isct isct],[x x],':','Color',g);
    plot([-x -x],[-isct isct],':','Color',g);
end
plot([-lm lm],[0 0],':','Color',0.8*g);     %axis at zero is darker
plot([0 0],[-lm lm],':','Color',0.8*g);
plot([-lm -lmi],[0 0],':','Color',0.5*g);   %axis out to infinity
plot([0 0],[-lm -lmi],':','Color',0.5*g);
plot([lm lmi],[0 0],':','Color',0.5*g);
plot([0 0],[lm lmi],':','Color',0.5*g);

zoomButton_Callback([], [], handles);       %Zoom gh plot

% --- Executes on button press in StartButton.
function StartButton_Callback(~, ~, handles)
sPath(handles, 0);  %Circular path, fast

function SlowButton_Callback(~, ~, handles)
sPath(handles, 0.1);  %Circular path, slow

% --- Executes on selection change in BISysMenu.
function BISysMenu_Callback(~, ~, handles)
% hObject    handle to BISysMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tfNum=get(handles.BISysMenu,'value');
myTF=handles.BItfs{tfNum};
if (tfNum==1),
    set(handles.pathDrawPanel,'Visible','off');
    set(handles.expPanel,'Visible','off');
    warndlg('No transfer function chosen');
else
    initAxes(handles);
    axes(handles.sDomAx);
    mappz(myTF);
    set(handles.pathDrawPanel,'Visible','on');
    set(handles.userSysMenu,'value',1);
end

handles.tf=myTF;
dispTF(handles);
guidata(handles.NyqGuiFig, handles); % Update handles structure


% --- Executes during object creation, after setting all properties.
function BISysMenu_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in limitationButton.
function limitationButton_Callback(~, ~, ~)
s={ '* Time delays are ignored.  (You can add them by altering the',...
    '  code in function ''pathInterp'', but do so at your own risk.)',...
    '* The drawing of the angle subtended by the path in "L(s)"',...
    '  is not meaningful in the case of marginally stable systems).',...
    '  (i.e., marginally stable systems.',...
    '* The imaginary part of poles very near the imaginary axis are ',...
    '   rounded to zero (i.e., the poles are placed on the axis).',...
    '* User-defined functions are loaded when program starts.  Any ',...
    '  functions added while program runs do not appear in the list.',...
    ' ',...
    '* Axes are fixed; poles, zeros and gains must be chosen',...
    '  accordingly.',...
    '  This is not meant to be a general tool for plotting Nyquist',...
    '  diagrams, but rather a tool for learning the associated',...
    '  concepts.'};
helpdlg(s,'Program Limitations');


function initSysLists(handles)
% Builtins
x={ 'Built-in Systems',[];...
    'PoleOrig',tf(10,[1 0]);...
    'ZeroOrig',tf([1 0],1);...
    'PoleNeg4',tf(10,[1 4]);...
    'ZeroNeg4',tf([1 4],1);...
    'PoleNeg6',tf(10,[1 6]);...
    'ZeroNeg6',tf([1 6],1);...
    'PolesConj',tf(100,[1 4 20]);...
    'PolesP6M4',tf(48,[1 -2 -24]);...
    'Pole4_8',tf(10,[1 4.8]);...
    'PZ',tf([1 -2],[1 4]);...
    'Polesjw',tf(16,[1 0 16]);...
    'DoubleInt',zpk([],[0 0],1);...
    'CondStable',zpk([],[-1 -2 -3],30);...
    'SlightlyUnstable',zpk(-3,[2j -2j -2],10);...
    'BarelyStable',zpk(-2,[2j -2j -3],10);...
    'Example 1',tf(90,[1 9 18]);...
    'Example 2',tf(20,[1 5 6]);...
    'Example 2b',tf(100,[1 5 6]);...
    'Example 3',tf(10*[1 3],[1 0 -4]);...
    'Example 4',tf(50*[1 3],[1 -1 11 -51]);...
    'Example 5',tf(10*[1 2],[1 3 0 0]);...
    'Example 5b',tf(10*[1 4],[1 3 0 0])};
set(handles.BISysMenu,'String',x(:,1));
handles.BItfs=x(:,2);
set(handles.BISysMenu,'Value',1);   % Put top value in menu

s=evalin('base','whos(''*'')');
tfs=char(s.class);             %x=class of all variable
tfs=strcmp(cellstr(tfs),'tf'); %Convert to cell array and find tf's
s=s(tfs);                      %Get just tf's
vname=char(s.name);
x=cell(length(s)+1,2);
j=1;
x{j,1}='User Systems';
for i=1:length(s)
    myTF=evalin('base',vname(i,:));
    if (size(myTF.num,1)==1),
        j=j+1;
        x{j,1}=vname(i,:);
        x{j,2}=myTF;
    end
end
set(handles.userSysMenu,'String',x(1:j,1));
handles.Usertfs=x(1:j,2);
set(handles.userSysMenu,'Value',1);   % Put top value in menu
guidata(handles.NyqGuiFig, handles); % Update handles structure

function dispTF(handles)
% This function displays a tranfer function that is a helper function.
% It takes the transfer function of the and splits it
% into three lines so that it can be displayed nicely.  For example:
% "            s + 1"
% "H(s) = ---------------"
% "        s^2 + 2 s + 1"
% The numerator string is in the variable nStr,
% the second line is in divStr,
% and the denominator string is in dStr.
if isempty(handles.tf),
    nStr=blanks(50);
    dStr=blanks(50);
    divStr='No system to display, choose one';
else
    % Get numerator and denominator.
    [n,d]=tfdata(handles.tf,'v');
    % Set very small values to zero
    n=n.*(abs(n)>1e-6);
    d=d.*(abs(d)>1e-6);
    % Get string representations of numerator and denominator
    nStr=poly2str(n,'s');  dStr=poly2str(d,'s');
    % Find length of strings.
    LnStr=length(nStr);  LdStr=length(dStr);
    
    if LnStr>LdStr,
        %the numerator is longer than denominator string, so pad denominator.
        n=LnStr;                  %n is the length of the longer string.
        nStr=['      ' nStr];   %add spaces for characters at start of divStr.
        dStr=['      ' blanks(floor((LnStr-LdStr)/n)) dStr]; %pad denominator.
    else
        %the demoninator is longer than numerator, pad numerator.
        n=LdStr;
        nStr=['      ' blanks(floor((LdStr-LnStr)/n)) nStr];
        dStr=['      ' dStr];
    end
    divStr='L(s)= ';
    divStr=[divStr strrep(blanks(n),' ','-')];
end
set(handles.tfText,'String',{nStr,divStr,dStr});
%Change type font and size.
set(handles.tfText,'FontName','Courier New')
set(handles.tfText,'FontSize',10)

function mappz(myTF)
[z,p]=zpkdata(myTF,'v');
plot(real(z),imag(z),'bo','Markersize',8)
plot(real(p),imag(p),'bx','Markersize',10);


% --- Executes on button press in zoomButton.
function zoomButton_Callback(~, ~, handles)
% hObject    handle to zoomButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.ghDomAx);
if get(handles.zoomButton, 'Value')==0
    axis((handles.axInf)*[-1 1 -1 1]);
    set(handles.zoomButton,'String','Zoom in');
else
    axis(handles.axNumLim/5*[-1 1 -1 1]);
    set(handles.zoomButton,'String','Zoom out');
end
guidata(handles.NyqGuiFig, handles); % Update handles structure


% --- Executes on selection change in userSysMenu.
function userSysMenu_Callback(~, ~, handles)
tfNum=get(handles.userSysMenu,'value');
myTF=handles.Usertfs{tfNum};
if (tfNum==1),
    set(handles.pathDrawPanel,'Visible','off');
    set(handles.expPanel,'Visible','off');
    warndlg('No transfer function chosen');
else
    initAxes(handles);
    axes(handles.sDomAx);
    mappz(myTF);
    set(handles.pathDrawPanel,'Visible','on');
    set(handles.BISysMenu,'value',1);
end

handles.tf=myTF;
dispTF(handles);
guidata(handles.NyqGuiFig, handles); % Update handles structure


% --- Executes during object creation, after setting all properties.
function userSysMenu_CreateFcn(hObject, ~, ~)
% hObject    handle to userSysMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function sPath(handles, del)
rinf=1000;
rDetour=0.4;        % This is the drawn radius of a detour around a pole.
epsln = 0.001;      % This is the precision for rounding location of any
% poles near jw axis (imag part of pole must be greater
% than epsln).
set(handles.pauseTButton,'Value',0);
set(handles.pauseTButton,'String','Pause');
axis((handles.axInf)*[-1 1 -1 1]);
set(handles.expPanel,'Visible','off');

[z,p,k]=zpkdata(handles.tf,'v');
% If pole is near imag axis, put it on the axis (set real part=0)
is_onaxis=abs(real(p))<epsln;  % is_onaxis=1 if pole is near axis.
p=complex(real(p).*(~is_onaxis),imag(p));  %If on axis, make p pure imaginary.
handles.tf=zpk(z,p,k);
dispTF(handles);

handles.gh_path_inf=0;               %path in gh gets to inf?
guidata(handles.NyqGuiFig, handles); % Update handles structure
initAxes(handles);
axes(handles.sDomAx);
mappz(handles.tf);
n=handles.nth;

hold on;
if get(handles.NyqPathRButt,'Value')
    % The Nyquist path is the hardest to create, because we must accomodate
    % detours around poles on the jw axis.  To make the plot look right
    % the detours will be large enough to see on the s-domain plot.
    % However, we'll keep track of when the path is on the detour and use
    % this information in the plot (we'll simply extend the radius of the
    % GH domain plot to infinity.
    p_at_origin=sum(abs(p)<epsln)~=0;       %See if we have poles at origin.
    p_gt_0=p(imag(p(is_onaxis))>=epsln);    %find all positive poles on axis.
    p_onax=sort(p_gt_0);                    %sort all of the poles.
    n_onax=length(p_onax);                  %number on axis.
    
    
    %  If there is a pole at the origin, put detour on path.
    if p_at_origin,
        theta=linspace(0,pi/2,n/4);
        x=rDetour*cos(theta);               %Plot detour (large)
        y=rDetour*sin(theta);
        ondet=ones(size(x));                %This variable indicates we are
        %on detour.
    else
        x=0;    %else start path at origin (for both plot and calc)
        y=0;
        ondet=zeros(size(x));               %We are not on detour.
    end
    
    % Path now goes up the imag axis
    thet=linspace(-pi/2,pi/2,n);
    for i=1:n_onax,  %Loop through poles on axis
        %First extend path up to the current pole (plot),
        ynew = linspace(y(end), imag(p_onax(i))-rDetour, n/(n_onax+1));
        y=[y ynew];
        x=[x zeros(size(ynew))];
        ondet=[ondet zeros(size(ynew))];    %Not on detour
        %Now make detour
        y=[y imag(p_onax(i))+rDetour*sin(thet)];
        x=[x rDetour*cos(thet)];
        ondet=[ondet ones(size(thet))];     %On detour
    end
    % Now complete path up ro the top of the axis.
    ynew = linspace(y(end),2*handles.axNumLim,2*n);
    y=[y ynew];
    x=[x zeros(size(ynew))];
    ondet=[ondet zeros(size(ynew))];
    
    
    
    
    % Now make entire path - add quarter of circle at infinity (to get path
    % back to real axis, thereby completing the path on the upper half of
    % the s plane.  We then complete path by extending the path with its
    % complex conjugate to get lower half of s-plane.
    thet=linspace(pi/2,0,n/2);              % Angles for quarter circle.
    x=[x rinf*cos(thet)];                   % Add quarter circle.
    y=[y rinf*sin(thet)];
%    x=[x fliplr(x)];                        % Add lower half of s-plane.
%    y=[y -fliplr(y)];
    % We know the rest of the path won't have detours, so extend array
    % that indicates detours with zeros.
%    ondet = [ondet zeros(size(thet))]; ondet=[ondet fliplr(ondet)];
ondet=[ondet zeros(size(thet))];
    
    pathInterp(x,y,ondet,del,handles);
    axes(handles.ghDomAx);
    text(-1,0,'+','HorizontalAlignment','Center',...
        'FontSize',14,'FontWeight','demi');
    if(~get(handles.pauseTButton,'Value')),
        nyqPathExplain(handles);
    end
elseif get(handles.circPathRButt,'Value')
    r=handles.circRad;
    thet=linspace(0,pi,n+1);
    x0=r*cos(-thet);  y0=r*sin(-thet);
    pathInterp(x0,y0,zeros(size(x0)),del,handles);
    if(~get(handles.pauseTButton,'Value')),
        nyqCircExplain(handles);
    end
else
    beep;
    errordlg('One radio button must be pushed.');
end

function pathInterp(x0,y0,ondet0,del,handles)
maxlen=10000;
x=zeros(1,maxlen);  y=zeros(1,maxlen);  ondet=zeros(1,maxlen);
j=1; %Counter for x0,y0
i=1; %Counter for x,y
x(1)=x0(1);  y(1)=y0(1);  ondet(1)=ondet0(1);
dx=x0(2)-x0(1);  dy=y0(2)-y0(1);
dx0=abs(dx);     dy0=abs(dy);
s=complex(x(1),y(1));
%If you want a time delay, uncomment the next line and add desired delay.
%handles.tf=handles.tf*tf(1,1,'InputDelay',0.5);
gh_old=freqresp(handles.tf,s); %gha_old=angle(gh_old);
while ( (i<maxlen) && (j<(length(x0))) ),
    x_nxt=x(i)+dx;  y_nxt=y(i)+dy;
    s=complex(x_nxt,y_nxt);
    gh=freqresp(handles.tf,s);  %gha=angle(gh);
    %     diffAngle=abs(gha-gha_old);
    %     if diffAngle>1.5*pi,
    %         diffAngle=abs(diffAngle-2*pi);
    %     end
    % diffAngle=0;
    if abs(gh)<handles.axInf,
        maxDiff=0.05;
    else
        maxDiff=0.2;
    end
%    if (((abs((gh-gh_old)/gh)>maxDiff) || (diffAngle>0.001)) && (abs(gh)>0.02)),
    if ((abs((gh-gh_old)/gh)>maxDiff)  && (abs(gh)>0.02)),
        dx=dx/2;   dy=dy/2;
    else
        if ( (abs(x_nxt-x0(j))>=dx0) || (abs(y_nxt-y0(j))>=dy0) ),
            j=j+1;
            x_nxt=x0(j);  y_nxt=y0(j);
            s=complex(x_nxt,y_nxt);
            gh=freqresp(handles.tf,s); % gha=angle(gh);
            if j~=length(x0),
                dx=x0(j+1)-x0(j);  dy=y0(j+1)-y0(j);
                dx0=abs(dx);       dy0=abs(dy);
            end
        end
        i=i+1;
        x(i)=x_nxt;  y(i)=y_nxt;    % Here we assign the values of x and y
        ondet(i)=ondet0(j);
        gh_old=gh; %gha_old=gha;
        dx=dx*1.4;  dy=dy*1.4;
    end
end
if i==maxlen,
    warndlg('Large changes in L(s), plot inaccurate.');
end
ondet=ondet(1:i);
s=complex(x(1:i),y(1:i));
gh=freqresp(handles.tf,s);
gh=transpose(gh(:));
mltp = 1+999*ondet;     %multiplier array - if ondet, multiply by 1000
gh=gh.*mltp;

s(end+1)=s(end);
gh(end+1)=gh(end);

plotPath(handles,s,gh,del);  %Make plot
handles=guidata(handles.NyqGuiFig);  % Reload handles

function plotPath(handles,s,gh,del)
alph=0.25;      %Colors (and transparency) used in plots
zcol=[1 0 0];
pcol=[0 0 1];
gcol=[1 1 1]*0.25;


arr=zeros(size(s));
arr([10 floor((1:4)*(length(s)/5)) end-12 end-4])=1;


s=[s fliplr(conj(s)) s(1)];
gh=[gh fliplr(conj(gh)) gh(1)];
arr=[arr fliplr(arr) 0];

% Get real and imaginary parts of s, and truncate large values.
r_s=abs(s);
i=find(r_s>(handles.axInf));  % too large
s(i)=s(i)*(handles.axInf)./r_s(i);
sr=real(s);  si=imag(s); 

% Get real and imaginary parts of gh, and truncate large values.
r_gh=abs(gh);
i=find(r_gh>(handles.axInf));  % too large
gh(i)=gh(i)*(handles.axInf)./r_gh(i);
if ~isempty(i),
    handles.gh_path_inf=1;               %path in gh gets to inf?
    guidata(handles.NyqGuiFig, handles); % Update handles structure
end
gr=real(gh);  gi=imag(gh);

% % Calculate the cummulative arclength (while s<inf)
% arclen=[0 sqrt(cumsum((diff(sr).^2+diff(si).^2).*...
%     ((r_s(2:end)<handles.axInf))))];
arclen=[0 cumsum(abs(diff(s))+abs(diff(gh)))];
maxarclen=max(arclen);
c=hsv2rgb([arclen/maxarclen; ones(2,length(arclen))]');  %colormap

if  get(handles.NyqPathRButt,'Value')
    ghx0=-1;
else
    ghx0=0;
end

%Get poles and zeros
[z,p]=zpkdata(handles.tf,'v');

% Create patches for showing angle of zeros (s domain) and precalculate
% angles.
azs=zeros(length(z),length(s));
%za=zeros(length(z),length(s)-1);
zp=zeros(length(z));  zl=zeros(length(z));
axes(handles.sDomAx);
for j=1:length(z),
    azs(j,:)=unwrap(angle(s(:)-z(j)));  %angle from s to z(j)
    %    za(j,:)=cumsum(diff(azs(j,:)));
    % zp is patch showhing cumulative angle from zero to s.  It is defined
    % here but not used until later.
    % zl is a line from origin to s.
    zp(j)=patch([0 0 ],[0 0],zcol,...
        'FaceColor',zcol,'FaceAlpha',alph,...
        'EdgeColor',zcol,'EdgeAlpha',alph*0.5);
    zl(j)=line([0 0],[0 0],'Color',zcol,'Linestyle',':');
end


% Create patches for showing angle of poles (s domain), and precalculate
% angles.
aps=zeros(length(p),length(s));
%pa=zeros(length(p),length(s)-1);
pp=zeros(length(p));  pl=zeros(length(p));
for j=1:length(p),
    aps(j,:)=unwrap(angle(s(:)-p(j)));
    %    pa(j,:)=cumsum(diff(aps(j,:)));
    pp(j)=patch([0 0 ],[0 0],pcol,...
        'FaceColor',pcol,'FaceAlpha',alph,...
        'EdgeColor',pcol,'EdgeAlpha',alph*0.5);
    pl(j)=line([0 0],[0 0],'Color',pcol,'Linestyle',':');
end

% Create patches for showing angle of gh path
axes(handles.ghDomAx);
agh=unwrap(angle(gh-ghx0));
%ga=cumsum(diff(agh));

gp=patch([0 0 ],[0 0],gcol,'FaceAlpha',alph,'EdgeAlpha',alph*0.5);
gl=line([0 0],[0 0],'Color',gcol,'Linestyle',':');

zr=real(z); zi=imag(z); pr=real(p); pi=imag(p);
i=1;
while i<(length(s)-1),
    if get(handles.pauseTButton,'Value'),
        pause(0.5);
    else
        axes(handles.sDomAx);
        % Plot s path (changing color as we go)
        plot([sr(i) sr(i+1)],[si(i) si(i+1)],'Color',c(i,:),'Linewidth',1.5);
        % Draw lines from z(j) to s, and fill in patch showing subtended angle.
        for j=1:length(z),
            %th=azs(j,1)+linspace(0,za(j,i),20);
            th=linspace(azs(j,1),azs(j,i+1),20);
            set(zp(j),'XData',[zr(j) zr(j)+cos(th)],'YData',[zi(j) zi(j)+sin(th)])
            set(zl(j),'XData',[zr(j) sr(i+1)],'YData',[zi(j) si(i+1)]);
        end
        for j=1:length(p),
            %th=aps(j,1)+linspace(0,pa(j,i),20);
            th=linspace(aps(j,1),aps(j,i+1),20);
            set(pp(j),'XData',[pr(j) pr(j)+cos(th)],'YData',[pi(j) pi(j)+sin(th)])
            set(pl(j),'XData',[pr(j) sr(i+1)],'YData',[pi(j) si(i+1)]);
        end
        
        axes(handles.ghDomAx);
        plot([gr(i) gr(i+1)],[gi(i) gi(i+1)],'Color',c(i,:),'Linewidth',2);
        %th=agh(1)+linspace(0,ga(i),abs(ga(i))*2+20);
        th=linspace(agh(1),agh(i+1),abs(agh(i+1)-agh(1))*2+20);
        if (agh(i+1)>0),
            gcol=pcol;
        else
            gcol=zcol;
        end
        set(gp,'XData',ghx0+[0 cos(th)],'YData',[0 sin(th)],...
                'EdgeColor',gcol,'FaceColor',gcol);
        set(gl,'XData',[ghx0 gr(i+1)],'YData',[0 gi(i+1)],...
            'Color',gcol);
        
        if arr(i)~=0,
            sarr_a=atan2(si(i+1)-si(i),sr(i+1)-sr(i));
            garr_a=atan2(gi(i+1)-gi(i),gr(i+1)-gr(i));
            axes(handles.sDomAx);
            angleArrow(sr(i), si(i), sarr_a, c(i,:));
            axes(handles.ghDomAx);
            angleArrow(gr(i), gi(i), garr_a, c(i,:));
        end
        pause(del);
        i=i+1;
    end
end


function angleArrow(tx,ty,thet,c)
x=0.5*[-0.75 1 -0.75];
y=0.3*[-1 0 1];
pts=[ cos(thet) -sin(thet) tx;
    sin(thet)  cos(thet) ty;
    0 0 1;]*[x; y; ones(size(x))];
x=pts(1,:);  y=pts(2,:);
patch(x,y,c,'EdgeColor',c,'FaceAlpha',0.5,'EdgeAlpha',0.5);


% --- Executes on button press in pauseTButton.
function pauseTButton_Callback(~, ~, handles)
% hObject    handle to pauseTButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.pauseTButton,'Value'),
    set(handles.pauseTButton,'String','Play');
else
    set(handles.pauseTButton,'String','Pause');
end


function nyqCircExplain(handles)
r=handles.circRad;
[z,p]=zpkdata(handles.tf,'v');
nz=length(z);
nzi=sum(abs(z)<r);
np=length(p);
npi=sum(abs(p)<r);
N=nzi-npi;
s1=['The transfer function has ' num2str(nz) ' zero(s) and '...
    num2str(np) ' pole(s).'];
s2=['The s-domain path encircles ' num2str(nzi) ' zero(s) and '...
    num2str(npi) ' pole(s) in a CW direction.'];
s3=['Z=' num2str(nzi) ', P=' num2str(npi) ', and N=Z-P=' num2str(N)];
s4=' ';
s5=['Thus the path in GH encirles the origin ' num2str(N) ' time(s) '...
    ' CW, or ' num2str(-N) ' time(s) CCW.'];
if handles.gh_path_inf~=0
    s6=' ';
    s7=['Note: GH was large enought that it had to be shown at '...
        'infinity for part of the path.'];
    s={s1;s2;s3;s4;s5;s6;s7};
else
    s={s1;s2;s3;s4;s5};
end
set(handles.expText,'String',s);
set(handles.expPanel,'Visible','on');

function nyqPathExplain(handles)
r=handles.circRad;
[z,p]=zpkdata(handles.tf,'v');
% Assume poles very near jw axis are on jw axis
p_offax=abs(real(p))>1e-5;
p=complex(real(p).*p_offax,imag(p));
P=sum(real(p)>0);

tfcl=minreal(feedback(handles.tf,1));       %System with feedback.
[zcl,pcl]=zpkdata(tfcl,'v');
% Assume poles very near jw axis are on jw axis
p_offax=abs(real(pcl))>1e-5;
p_onax=~p_offax;
pcl=complex(real(pcl).*p_offax,imag(pcl));
Z=sum(real(pcl)>0);

N=Z-P;
s1=['The open-loop transfer function, L(s), has P=' num2str(P)...
    ' pole(s) in the RHP.'];
s2=['The s-domain path encircles the origin N=' num2str(N) ' time(s) '...
    'in a CW direction.'];
s3=['Therefore the closed loop transfer function has Z=N+P='...
    num2str(Z) ' pole(s) in the RHP (' num2str(Z)...
    ' zero(s) of c.e. in RHP)'];
if (Z>0) 
    s4 = 'The system is unstable.';
else
    s4 = 'The system is stable.';
end
s5=' ';
if sum(p_onax)~=0,
    s6=['"L(s)" path goes through -1+j0, so there are some closed ',...
        'loop poles on jw axis.'];
    s7='The angles drawn on the "L(s)" plot may be inaccurate!'; 
    s={s1;s2;s3;s4;s5;s6;s7};
else
    s={s1;s2;s3;s4};
end
set(handles.expText,'String',s);
set(handles.expPanel,'Visible','on');

% --- Executes on button press in clearPButton.
function clearPButton_Callback(~, ~, handles)
initAxes(handles);
    axes(handles.sDomAx);
    mappz(handles.tf);

% --- Executes on button press in webPB.
function webPB_Callback(hObject, eventdata, handles)
web('http://lpsa.swarthmore.edu/Nyquist/Nyquist.html','-browser')
