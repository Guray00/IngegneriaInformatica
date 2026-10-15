function [vI, vS, Aeq, beq] = TSP(c, n)
% Restituisce le valutazioni di PLI Dato il vettore dei costi **SENZA I COSTI PER GLI ARCHI x_ii** 
% Addizionalmente restituisce anche la matrice Aeq e beq per il RC
% n: numero di nodi
% x_ij -> Parto da i arrivo in j

if(length(c) ~= n*n - n)
    disp("Numeri Sensati bro")
else
    C = 1e+5 * ones(1, n*n);
    k = 1;
    for i = 1 : n
        for j = 1 : n
            if(i ~= j)
                C(1, (i-1)*n + j) = c(k);
                k = k + 1;
            end
        end
    end
    disp("Matrice dei costi sovraccaricata: ");
    for i = 1 : n
        fprintf("\t");
        for j = 1 : n
            fprintf("%d\t", C(1, (i-1)*n + j));
        end
        fprintf("\n");
    end
    
    Aeq = zeros(2*n, n*n);
    beq = ones(2*n, 1);
    
    for i = 1 : n
        for j = 1 : n
            Aeq(i, j + (i-1)*n) = 1;
        end
    end
    
    for i = 1 : n
        for j = 1 : n
            Aeq(i + n, i + n*(j-1)) = 1;
        end
    end
    
    [x, v] = linprog(C, [], [], Aeq, beq, zeros(n*n, 1), ones(n*n, 1));
    

    vI = ceil(v);
    vS = toppe(x, C, n);

    if(vI == vS)
        fprintf("v = vI = vS = %d", vI);
    else
        fprintf("v in [%d, %d]\n\n", vI, vS);
    end
end
end

function vS = toppe(x, c, n)
% Data una soluzione di un RC, un vettore dei costi (con costi diagonali) c e n nodi, applica l'Algoritmo delle toppe
    X = zeros(n);
    C = ones(n);

    k = 1;
    for i = 1 : n
        for j = 1 : n
            C(i, j) = c(k);
            X(i, j) = x(k);
            k = k + 1;
        end
    end

    disp("Matrice delle connessioni X: ");
    disp(X);
    
    i = 1;
    next = 1;
    cicli = 1;
    n_cicli = 1;
    while i < n
        next = find(X(next, 1:n) == 1);
        if(~ismember(next, cicli(n_cicli, :)))
            tmp = cicli(n_cicli, :);
            tmp = [tmp(tmp ~= 0), next];
            cicli(n_cicli, 1:length(tmp)) = tmp;
            i = i + 1;
        else
            next = 1;
            while ismember(next, cicli(n_cicli, :))
                next = next+ 1;
            end
            n_cicli = n_cicli + 1;
            cicli(n_cicli, 1) = next;
            i = i + 1;
        end
    end

    vS = floor(c * x);
    t = 1;
    while size(cicli, 1) ~= 1
        i = cicli(1, 1);
        j = cicli(1, 2);
        k = cicli(2, 1);
        l = cicli(2, 2);
        
        tmp = cicli(2, :);
        tmp = tmp(tmp ~= 0);
        tmp = [tmp(2:end), tmp(1)];
        cicli(1, 1: end + length(tmp)) = [cicli(1, 1), tmp, cicli(1, 2:end)];
        cicli(2, :) = [];

        X(i, j) = 0;
        X(k, l) = 0;
        X(i, l) = 1;
        X(k, j) = 1;

        fprintf("-----------------\n");
        fprintf("Passo %d: \n\n", t);
        disp("Matrice Aggiornata: ");
        disp(X);
        fprintf("Rimuovo: (%d, %d), (%d, %d)\n", i, j, k, l);
        fprintf("Aggiungo: (%d, %d), (%d, %d)\n\n", i, l, k, j);
        vS = vS - C(i, j) - C(k, l) + C(i, l) + C(k, j);
        fprintf("Nuova vS: %d\n\n", vS);
        t = t+1;
    end
end