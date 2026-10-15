function [v, xT, xL, p, cTnew, Tnew, cLnew, Lnew] = SimplessoReti(cT, T, cL, L, b, passi)
% cL si riferisce all'ordine in L, così come cT, xT con T.
% b è un vettore colonna che rappresenta i bilanci dei nodi (riga i -> nodo i)
% cL e cT sono vettori colonna con le stesse righe di L e T
% Le matrici T ed L sono matrici a due colonne dove:
%   - ogni riga indica un arco
%   - la prima colonna il nodo di partenza, la seconda quello di arrivo

if ( isempty(T) || isempty(cT) || ...
     isempty(L) || isempty(cL) || ...
     isempty(b) || ...
     any(size(T, 1) ~= size(cT, 1)) || ...
     any(size(L, 1) ~= size(cL, 1)) || ...
     (size(T, 2)  ~= 2) || ...
     (size(L, 2)  ~= 2) || ...
     (size(cT, 2) ~= 1) || ...
     (size(cL, 2) ~= 1) )
    
    disp("Numeri sensati bro");
    return;
end

if(isempty(passi))
    passi = 1;
end
n = [length(cT), length(cL)];     % [Variabili in base, Non di Base]
m = length(b);      % Numero nodi

v = Inf;
xT = [];
xL = [];
p = [];
[cT, T] = ordina(cT, T, xT);
[cL, L] = ordina(cL, L, xL);
miglioramento = Inf;

while passi > 0
    Tnew = T;
    Lnew = L;
    cTnew = cT;
    cLnew = cL;
    if(isempty(xT))
        [xT, xL] = baseAmmissibile(T, b, n);
    end
    
    nonAmm = 0;
    if(any(xT < 0))
        disp("------------------------");
        disp("| Base non Ammissibile |");
        disp("------------------------");
        nonAmm = 1;
    end
    disp("xT: ");
    for i = 1 : length(xT)
        fprintf("\t%d \t (%d, %d)", xT(i), T(i, 1), T(i, 2));
        if(xT(i) == 0)
            fprintf(" | (Degenere)");
        elseif(xT(i) < 0)
            fprintf(" | (NON AMMISSIBILE)");
        end
        fprintf("\n");
    end
       
    if(~nonAmm)
        v = cT' * xT;
        fprintf("\nv_attuale = %d \n", v);
    
        if(miglioramento ~= Inf)
            fprintf("Miglioramento di: %d\n", miglioramento);
        end
    end
    
    [p, k] = Potenziali(cT, T, cL, L, m);
    
    if(nonAmm)
        return
    end
    if(k == 0)
        disp("Soluzione Ottima Trovata");
        disp("vO = ");
        v = cT' * xT;
        disp(v);
        return;
    else
        [cT, T, cL, L, xT, xL, miglioramento] = simplessoCore(cT, T, xT, cL, L, xL, k, p);
    end
    
    if(miglioramento == Inf)
        disp("Il problema è illimitato");
        return;
    end
    passi = passi - 1;
end

Tnew = T;
Lnew = L;
cTnew = cT;
cLnew = cL;



disp("xT: ");
for i = 1 : length(xT)
    fprintf("\t%d \t (%d, %d)", xT(i), T(i, 1), T(i, 2));
    if(xT(i) == 0)
        fprintf(" | (Degenere)");
    end
    fprintf("\n");
end

[p, k] = Potenziali(cT, T, cL, L, m);

if(k == 0)
        disp("Soluzione Ottima Trovata");
        disp("vO = ");
        v = cT' * xT;
        disp(v);
end
end

function [xT, xL] = baseAmmissibile(T, b, n)
    disp("*************************************");    
    disp("* Verifico Ammissibilità della Base *");
    disp("*************************************");

    xT = zeros(n(1), 1);
    xL = zeros(n(2), 1);
    found = zeros(1, size(T, 1));
    while any(found == 0)
        
        for i = 1 : size(T, 1) 
            if(found(i) == 1)
                continue
            end
            count = sum(T(:, 1) == i) + sum(T(:, 2) == i);
            if(count == 1) % E' foglia
                found(i) = 1;
                row = find(T(:, 2) == i);
                if(isempty(row))
                    row = find(T(:, 1) == i);
                    xT(row) = -b(i);
                    b(T(row, 1)) = b(T(row, 1)) + xT(row);
                    b(T(row, 2)) = b(T(row, 2)) - xT(row);
                    T(row, :) = 0;
                else
                    xT(row) = b(i);
                    b(T(row, 1)) = b(T(row, 1)) + xT(row);
                    b(T(row, 2)) = b(T(row, 2)) - xT(row);
                    T(row, :) = 0;
                end
            end
        end        
    end
end

function [p, potDeg] = Potenziali(cT, T, cL, L, m)
    fprintf("\n************************\n");
    disp("* Calcolo i Potenziali *");
    disp("************************");

    p = zeros(m, 1);
    found = zeros(1, m);
    found(1) = 1;
    while any(found == 0)
        for i = 1 : length(p)
            if(~found(i))
                continue
            end
            % Trovo tutti gli archi uscenti da i
            row = find(T(:, 1) == i); 
            if(~isempty(row))
                % Se ci sono allora guardo dove vado e aggiorno
                for r = 1 : length(row)
                    j = T(row(r), 2);
                    found(j) = 1;
                    p(j) = p(i) + cT(row(r));
                end
            end
            % Controllo quindi quelli entranti
            row = find(T(:, 2) == i);
            if(~isempty(row))
                for r = 1 : length(row)
                    j = T(row(r, 1));
                    found(j) = 1;
                    p(j) = p(i) - cT(row(r));
                end
            end
        end
    end
    disp("p: ");
    disp(p');
    potDeg = 0;
    disp("Calcolo i costi ridotti non di base");
    for i = 1 : size(L, 1)
        k = L(i, 1);
        l = L(i, 2);
        ckl = cL(i) - p(l) + p(k);
        fprintf("Arco (%d, %d): c = %d \t", k, l, ckl);
        if(ckl == 0)
            fprintf(" (Degenere) \t");
        end
        if(ckl < 0)
            fprintf("Base non Ammissibile");
            if(potDeg == 0)
                potDeg = i;
            end
        end
        fprintf("\n");
    end
end

function [cNew, Tnew, xNew] = ordina(c, T, x)
    ended = 0;
    if(isempty(c))
        c = zeros(size(T, 1), 1);
    end
    if(isempty(x))
        x = c;
    end
    while ~ended
        ended = 1;
        for i = size(T, 1) : -1: 2
            if(T(i, 1) < T(i - 1, 1))
                ended = 0;
                T([i, i-1], :) = T([i-1, i], :);
                c([i, i-1]) = c([i-1, i]);
                x([i, i-1]) = x([i-1, i]);
            elseif((T(i, 1) == T(i - 1, 1)) && (T(i, 2) < T(i - 1, 2)))
                ended = 0;
                T([i, i-1], 2) = T([i-1, i], 2);
                c([i, i-1]) = c([i-1, i]);
                x([i, i-1]) = x([i-1, i]);
            end
        end

    end
    
    cNew = c;
    Tnew = T;
    xNew = x;
end

function [cT, T, cL, L, xT, xL, miglioramento] = simplessoCore(cT, T, xT, cL, L, xL, k, p)
% Se miglioramento è infinito allora il problema non ha soluzione
    fprintf("\n\n*********************************************\n");
    disp("* Applico l'algoritmo del Simplesso su Reti *");
    disp("*********************************************");

    kVett = [L(k, 1), L(k, 2)];
    fprintf("\n Arco entrante k: (%d, %d)\n\n", kVett(1), kVett(2));       



    % Funzione ricorsiva
    % T costante
    % il primo elemento è quello al quale voglio arrivare
    % il secondo quello dal quale parto
    [Cneg, Cpos] = ricercaCicli(T, kVett(1), kVett(2));
    
    
    Cpos = [kVett; Cpos];
    
    [~, Cpos] = ordina([], Cpos, []);
    [~, Cneg] = ordina([], Cneg, []);
    
    disp("C+: ");
    disp(Cpos);
    disp("C-:");
    disp(Cneg);
    
    if(isempty(Cneg))
        miglioramento = Inf; % Problema Illimitato
        return;
    end
    minimo = [Inf, -1];
    for i = 1 : size(Cneg, 1)
        indice = any(T == Cneg(i, 1), 2) & any(T == Cneg(i, 2), 2);
        indice = find(indice == 1);

        th = xT(indice);

        fprintf("Theta arco (%d, %d): %d\n", Cneg(i, 1), Cneg(i, 2), th);
        if(minimo(1) > th || (minimo(1) == th && indice < minimo(2)))
            minimo = [th, indice];
        end
    end
    
    
    th = minimo(1);
    h = minimo(2);
    clear minimo

    hVett = [T(h, 1), T(h, 2)];
    fprintf("\ntheta  = %d\n", th);
    fprintf("Arco Uscente h = (%d, %d)\n\n", hVett(1), hVett(2) )
    
    T = [T; L(k, :)];
    cT = [cT; cL(k)];
    xT = [xT; xL(k)];
    
    L(k, :) = [];
    cL(k) = [];
    xL(k) = [];
    
    % Il costo ridotto lo calcolo su quello entrante
    % che ho messo temporaneamente in fondo a cT
    miglioramento = th * (cT(length(cT)) - p(kVett(2)) + p(kVett(1)));

    for i = 1 : size(Cpos, 1)
        indice = any(T == Cpos(i, 1), 2) & any(T == Cpos(i, 2), 2);
        indice = find(indice == 1);
        
        xT(indice) = xT(indice) + th;
    end

    for i = 1 : size(Cneg, 1)
        indice = any(T == Cneg(i, 1), 2) & any(T == Cneg(i, 2), 2);
        indice = find(indice == 1);

        xT(indice) = xT(indice) - th;
    end
    
    L = [L; T(h, :)];
    cL = [cL; cT(h)];
    xL = [xL; 0];

    T(h, :) = [];
    cT(h) = [];
    xT(h) = [];

    [cT, T, xT] = ordina(cT, T, xT);
    [cL, L, xL] = ordina(cL, L, xL);
end

function [Cneg, Cpos, upd] = ricercaCicli(Tora, endPoint, startPoint)
% upd serve per comunicare a quello prima se ho fatto cambiamenti o meno
    upd = 0;
    Cneg = [];
    Cpos = [];
    rowPlus = find(Tora(:, 1) == startPoint);
    if(~isempty(rowPlus))
        endPlus = Tora(rowPlus, 2);
        tmp = Tora(rowPlus, :);
        Tora(rowPlus, :) = [];
    
        for i = 1 : length(endPlus)
            if(endPlus(i) == endPoint)
                Cpos = [Cpos; tmp(i, :)];
                upd = 1;
                return;
            end
            [Cneg, Cpos, upd] = ricercaCicli(Tora, endPoint, endPlus(i));
            if(upd)
                Cpos = [Cpos; tmp(i, :)];
                upd = 1;
                return;
            end
        end
    end
    rowMinus = find(Tora(:, 2) == startPoint);
    if(~isempty(rowMinus))
        endMinus = Tora(rowMinus, 1);
        tmp = Tora(rowMinus, :);
        Tora(rowMinus, :) = [];

        for i = 1 : length(endMinus)
            if(endMinus(i) == endPoint)
                Cneg = [Cneg; tmp(i, :)];
                upd = 1;
                return;
            end
            [Cneg, Cpos, upd] = ricercaCicli(Tora, endPoint, endMinus(i));
            if(upd)
                Cneg = [Cneg; tmp(i, :)];
                upd = 1;
                return;
            end
        end
    end

end