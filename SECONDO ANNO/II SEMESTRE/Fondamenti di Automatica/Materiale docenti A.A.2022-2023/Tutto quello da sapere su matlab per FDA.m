
%% Comandi di matlab utili per il corso di FDA

% Definire s e funzioni di trasferimento
s = tf([1 0], [1])
% Ad esempio...
G = (s+1)/((s+5)*(s+0.5))

% Trovare i poli e gli zeri
zero(G)
pole(G)
% ... e disegnarli su un grafico
pzmap(G)

% Trovare i margini di guadagno e di fase
margin(G)

% Tracciare i diagrammi di bode, nyquist e root locus
bode(G)
nyquist(G)
rlocus(G)

% Risposta del sistema alla funzione gradino
step(G)
% ... più informazioni sulla risposta (es: overshoot)
stepinfo(G)

% Sistema in retroazione unitario
H = feedback(G, 1)

% E' uguale a fare H = G / (1 + G) ma usando feedback
% semplifica eventuali poli/zeri in comune

% Per fare le antitrasformate di laplace non si può passare
% la funzione di trasferimento ma bisogna riscriverla col
% symbolic toolbox, chiamo dunque S grande la variabile
% perchè s è già quella di prima
syms S
G_s = (S+1)/((S+5)*(S+0.5))
% Expand serve per semplificare le espressioni
G_t = expand(ilaplace(G_s))
% Se la si vuole avere coi valori numerici
digits(2) % ... oppure il numero di cifre desiderato
vpa(G_t)
% Se ne si vuole fare il grafico
fplot(G_t, [0, 10]) % Oppure un intervallo a piacere


% Per fare due grafici su finestre diverse si usa figure:
bode(G);
figure;
nyquist(G);

% Mentre per fare più grafici sulla stessa finestra si usa hold:
bode(G);
hold on;
bode(10*G);
bode(100*G);
hold off;

% Se si vuole tracciare un punto sul grafico si usa plot:
plot(x,y,'r*') % r* vuol dire che il punto è un * rosso

% Per fare gli esercizi sulle matrici è invece molto utile il
% sito realizzato da un nostro compagno di corso: 
%   http://fda.mattebernini.online/#matrici

