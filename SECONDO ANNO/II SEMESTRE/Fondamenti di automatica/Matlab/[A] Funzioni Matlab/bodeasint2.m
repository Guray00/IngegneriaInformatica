% function bodeasint2(num,den,wmin,wmax)
% function bodeasint2(sys,wmin,wmax)
%
% Diagrammi di Bode asintotici e reali
% num,den = vettori con i coeff. del numeratore e del denominatore ordinati
% secondo potenze decrescenti di s
% sys = sistema, deve essere convertibile in 'trasfer function' (tf)
% wmin, wmax = valore minimo e massimo della pulsazione

function bodeasint2(varargin)

if length(varargin) == 4
   num = varargin{1};
   den = varargin{2};
   wmin = varargin{3};
   wmax = varargin{4};
elseif length(varargin) == 3
    sys = varargin{1};
    
    if ~isa(sys, 'tf')
        sys = tf(sys);
    end
    
    wmin = varargin{2};
    wmax = varargin{3};
    
    num = sys.num{1};
    den = sys.den{1};
else
    error('Numero di argomenti errato');
end

% Eliminazione di coefficienti = 0 in testa a num e den
first_n = find(num ~= 0, 1);
num = num(first_n:length(num));
if isempty(num)
    num = 0;
end

first_d = find(den ~= 0, 1);
den = den(first_d:length(den));

if isempty(den)
    den = 0;
end

assert(num(1) ~= 0 || length(num) == 1);
assert(den(1) ~= 0 || length(den) == 1);

% ARROTONDAMENTO DEGLI ESTREMI
dmin=floor(log10(wmin));
dmax=ceil(log10(wmax));
wmin=10^dmin; wmax=10^dmax;

% CALCOLO DI ZERI, POLI E GUADAGNO
nn=length(num)-1; % grado del numeratore (numero di zeri)
nd=length(den)-1; % grado del denominatore (numero di poli)
poli=roots(den); % vettore di poli
zeri=roots(num); % vettore di zeri
numz=num(num~=0); kn=numz(length(numz)); 
denz=den(den~=0); kd=denz(length(denz)); 
guad=kn/kd; % guadagno di Bode

% COSTRUZIONE DEL VETTORE DELLE ASCISSE
nomega=1; % indice del vettore delle ascisse 
omega(nomega)=wmin; % vettore ascisse inizializzato a wmin
for i=1:nd
  om=abs(poli(i));
  if om>wmin && om<wmax
    nomega=nomega+1; omega(nomega)=om; % memorizzazione poli
  end
end
for i=1:nn
  om=abs(zeri(i));
  if om>wmin & om<wmax
    nomega=nomega+1; omega(nomega)=om; % memorizzazione zeri
  end
end
nomega=nomega+1; omega(nomega)=wmax; % memorizzazione di wmax

% CALCOLO DEL DIAGRAMMA DEL MODULO
bm=zeros(length(omega)); % vettore delle ordinate del modulo
for j=1:nomega
  bm(j)=guad; % azione guadagno
  for i=1:nd % azione poli
    om=abs(poli(i));
    if om==0
      bm(j)=bm(j)/omega(j);
    elseif om<omega(j)
      bm(j)=bm(j)*om/omega(j);
    end
  end
  for i=1:nn % azione zeri
    om=abs(zeri(i));
    if om==0
      bm(j)=bm(j)*omega(j);
    elseif om<omega(j)
      bm(j)=bm(j)*omega(j)/om;
    end
  end
end
[omegas,ind]=sort(omega); % ordinamento delle pulsazioni di spezzamento
bms=bm(ind); % vettore degli spezzamenti per il modulo

% CALCOLO DEL DIAGRAMMA DELLA FASE

for j=1:nomega
  bf(j)=0; % vettore fasi inizializzato
  for i=1:nd % azione poli
    om=abs(poli(i));
    if om<omega(j)
      if real(poli(i))>0
        bf(j)=bf(j)+90;
      else
        bf(j)=bf(j)-90;
      end
    end
  end
  for i=1:nn % azione zeri
    om=abs(zeri(i));
    if om<omega(j)
      if real(zeri(i))>0
        bf(j)=bf(j)-90;
      else
        bf(j)=bf(j)+90;
      end
    end
  end
  if guad<0 % azione guadagno
    bf(j)=bf(j)-180;
  end
end
bfs=bf(ind); % vettore degli spezzamenti per la fase
for i=1:nomega-1 % aggiunta di 'ridondanza doppia'
  omegasf(2*i-1)=omegas(i); % nel vettore delle pulsazioni di spezzamento
  omegasf(2*i)=omegas(i);
  bfsf(2*i-1)=bfs(i); % nel vettore degli spezzamenti per la fase
  bfsf(2*i)=bfs(i+1);
end
omegasf(2*nomega-1)=omegas(nomega);
bfsf(2*nomega-1)=bfs(nomega);

% TRACCIAMENTO DEI DIAGRAMMI

bms=20*log10(bms); % conversione in dB per il modulo (asintotico)
w=logspace(dmin,dmax,100); % creazione spazio logaritmico di 100 punti
   [mag,phase]=bode(num,den,w); % applicazione della funzione 'bode'
   mag=20*log10(mag); % conversione in dB per il modulo (reale)
   
% PARTE FIXATA: AGGIUSTAMENTO DEL DIAGRAMMA DELLA FASE
%________________________________________________________________
v=0; % differenza di molteplicità di zeri-poli nell'origine
for i=1:length(zeri) % conto gli zeri nell'origine
     if abs(zeri(i))==0
         v=v+1;
     end
end
for i=1:length(poli) % conto i poli nell'origine
    if abs(poli(i))==0
        v=v-1;
    end
end
fias=90*(v+sign(guad)-1); % fase asintotica per pulsazione nulla
[q,fire]=bode(num,den,0); % fase reale per pulsazione nulla
offset=fias-fire; % calcolo offset di traslazione
if offset ~= 0
    for i=1:length(phase) % aggiustamento dell'offset nelle fasi
        phase(i)=phase(i)+offset;
    end
end
%________________________________________________________________
   
%figure;

subplot(2,1,1),semilogx(w,mag,omegas,bms)
ylabel('|W| [dB]'),xlabel('pulsazione [rad/s]'),grid;
title('Diagramma di Bode - Modulo');


subplot(2,1,2),semilogx(w,phase,omegasf,bfsf)
ylabel('arg(W) [°]'),xlabel('pulsazione [rad/s]'),grid;
title('Diagramma di Bode - Fase');
   
end
