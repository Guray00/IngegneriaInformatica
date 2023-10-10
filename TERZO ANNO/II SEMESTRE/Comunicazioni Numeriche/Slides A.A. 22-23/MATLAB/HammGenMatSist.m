function [n,k,H,G] = HammGenMatSist(m)
% funzione che genera le matrice G e H di un codice di Hamming sistematico
% in funzione del parametro di ingresso m. Calcola e ordina la distanza
% delle parole di codice da una parola di codice di riferimento.

% dato m genero i parametri n, k del codice
n = 2^m-1;
k = 2^m-m-1;

H = zeros(n-k,n);
PT = zeros(n-k,k);

%% matrice di controllo di parita' in forma sistematica
muta = 1;

% genero le colonne della matrice di parita' che non appartengano alla
% matrice identica
for l = 1:n
    % nextpow2(l) restituisce il primo intero P tale che 2.^P >= abs(l).
    if l ~= 2^nextpow2(l)
        PT(:,muta) = int2bit(l,n-k).';
        muta = muta+1;
    end
end

% metodo alternativo per generare le colonne della matrice di parita': si
% cancellano le colonne che hanno soltanto 1 uno.
PT = int2bit(1:2^m-1,m);
weightVect = sum(PT);
indVect = find(weightVect==1);
PT(:,indVect) = [];

% matrice di controllo di parita'
H = [PT, eye(n-k)];
%matrice generatice del codice
G = [eye(k), PT'];

% verifico che il risultato sia 0
s = mod(G*H',2);

