function [potenziali, passi, cT, T, cL, L] = Dijsktra(c, G, start, n)
% c si riferisce all'ordine in G
% c è un vettore colonna le stesse righe di G
% La matrice G è una matrice a due colonne dove:
%   - ogni riga indica un arco
%   - la prima colonna il nodo di partenza, la seconda quello di arrivo
% n: numero di nodi
% start: nodo di partenza
% 

if ( isempty(G) || isempty(c) || ...
     isempty(start) || ...
     start < 0 || start > n || ...
     any(size(G, 1) ~= size(c, 1)) || ...
     (size(G, 2)  ~= 2) || ...
     (size(c, 2) ~= 1))

    disp("Numeri sensati bro");
    return;
end

[c, G] = ordina(c, G);
T = zeros(n-1, 2);
risultato = [Inf * ones(n, 1), zeros(n, 1) ];
N = 1:n;

risultato(start, :) = [0, start];

while ~isempty(N)
    disp("------------------------------------");
    [~, i] = min(risultato(N, 1));
    i = N(i);
    N(N == i) = [];
    
    fprintf("i: %d\n", i);
    fprintf("N: ");
    disp(N);

    rows = G(:, 1) == i;
    FS = [G(rows, 2), c(rows)];
    % FS(:, 1) => j
    % FS(:, 2) => costo arco (i, j)
    fprintf("FS(%d): ", i);
    disp(FS(:, 1)');
    for k = 1 : size(FS, 1)
        j = FS(k, 1);
        fprintf("j = %d \t|\t", j);
        pi_J = risultato(j, 1);
        pi_upd = risultato(i, 1) + FS(k, 2);
        
        fprintf("(π%d > π%d + c%d%d)? =>", j, i, i, j);
        if(pi_J > pi_upd)
            fprintf("Sì: %d > %d", pi_J, pi_upd);
            risultato(j, :) = [pi_upd, i];
        else
            fprintf("No: %d > %d", pi_J, pi_upd);
        end

        fprintf("\n");
    end

    fprintf("\nVettore aggiornato:\n");
    fprintf("π: ");
    disp(risultato(:, 1)');
    fprintf("p: ");
    disp(risultato(:, 2)');
end

potenziali = risultato(:, 1)';
passi = risultato(:, 2)';

disp("Albero di copertura: ");
k = 1;
for i = 1 : size(risultato, 1)
    if(i == start)
        continue
    end
    T(k, :) = [risultato(i, 2), i];
    k = k + 1;
end

rows = zeros(size(G, 1), 1);
for i = 1 : size(T, 1)
    rows = rows | G(:, 1) == T(i, 1) & G(:, 2) == T(i, 2);
end

T = G(rows, :);
cT = c(rows);
L = G(~rows, :);
cL = c(~rows);

disp(T);

fprintf("\nv: %d\n\n", sum(cT));
end

function [cNew, Tnew] = ordina(c, T)
    ended = 0;
    while ~ended
        ended = 1;
        for i = size(T, 1) : -1: 2
            if(T(i, 1) < T(i - 1, 1))
                ended = 0;
                T([i, i-1], :) = T([i-1, i], :);
                c([i, i-1]) = c([i-1, i]);
            elseif((T(i, 1) == T(i - 1, 1)) && (T(i, 2) < T(i - 1, 2)))
                ended = 0;
                T([i, i-1], 2) = T([i-1, i], 2);
                c([i, i-1]) = c([i-1, i]);
            end
        end

    end
    
    cNew = c;
    Tnew = T;
end