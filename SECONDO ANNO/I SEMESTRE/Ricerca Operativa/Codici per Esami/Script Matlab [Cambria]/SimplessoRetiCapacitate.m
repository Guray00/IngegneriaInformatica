function [v, xT, xL, xU, p, cTnew, Tnew, cLnew, Lnew, cUnew, Unew] = SimplessoRetiCapacitate(cT, T, cL, L, cU, U, b, passi)
%cL si riferisce all'ordine in L, così come cT, xT con T e cU con U.
% cX(:, 1) è il costo, cX(:, 2) è la portata


if ( isempty(T) || isempty(cT) || ...
     isempty(U) || isempty(cU) || ...
     isempty(L) || isempty(cL) || ...
     isempty(b) || ...
     any(size(T) ~= size(cT)) || ...
     any(size(U) ~= size(cU)) || ...
     any(size(L) ~= size(cL)) || ...
     (size(cT, 2) ~= 2) || ...
     (size(cU, 2) ~= 2) || ...
     (size(cL, 2) ~= 2) )
    
    disp("Numeri sensati bro");
    return;
end

if(isempty(passi))
    passi = 1;
end

n = [size(cT, 1), size(cL, 1), size(cU, 1)];        % [T, L, U]
m = length(b);                                      % Numero nodi
v = Inf;
xT = [];
xL = [];
xU = [];
p = [];
[cT, T] = ordina(cT, T, xT);
[cL, L] = ordina(cL, L, xL);
[cU, U] = ordina(cU, U, xU);
miglioramento = Inf;

while passi > 0
    Tnew = T;
    Lnew = L;
    Unew = U;
    cTnew = cT;
    cLnew = cL;
    cUnew = cU;

    if(isempty(xT))
        [xT, xL, xU] = baseAmmissibile(T, U, cU(:, 2), b, n);
    end
    
    nonAmm = 0;
    if(any(xT < 0) || any(xT > cT(:, 2)))
        disp("------------------------");
        disp("| Base non Ammissibile |");
        disp("------------------------");
        nonAmm = 1;
    end
    
    disp("xT: ");
    for i = 1 : length(xT)
        fprintf("\t%d \t (%d, %d)", xT(i), T(i, 1), T(i, 2));
        if(xT(i) == 0 || xT(i) == cT(i, 2))
            fprintf(" | (Degenere)");
        elseif(xT(i) < 0 || xT(i) > cT(i, 2))
            fprintf(" | (NON AMMISSIBILE");
            if(xT(i) > cT(i, 2))
                fprintf(", portata %d", cT(i, 2));
            end
            fprintf(")");
        end
        fprintf("\n");
    end
    
    disp("xU: ");
    for i = 1 : length(xU)
        fprintf("\t%d \t (%d, %d)\n", xU(i), U(i, 1), U(i, 2));
    end
    
    if(~nonAmm)
        v = cT(:, 1)' * xT+ cU(:, 1)' * xU;

        fprintf("\nv_attuale = %d \n", v);
    
        if(miglioramento ~= Inf)
            fprintf("Miglioramento di: %d\n", miglioramento);
        end
    end
    
    [p, k] = Potenziali(cT(:, 1), T, cL(:, 1), L, cU(:, 1), U, m);
    
    if(nonAmm)
        return
    end
    if(k(2) == -1)
        disp("Soluzione Ottima Trovata");
        v = cT(:, 1)' * xT + cU(:, 1)' * xU;
        disp("vO = ");
        disp(v);
        return;
    elseif(passi > 0)
        [cT, T, xT, cL, L, xL, cU, U, xU, miglioramento] = simplessoCore(cT, T, xT, cL, L, xL, cU, U, xU, k, p);
    end
    
    passi = passi - 1;
end

Tnew = T;
Lnew = L;
Unew = U;
cTnew = cT;
cLnew = cL;
cUnew = cU;

disp("xT: ");
for i = 1 : length(xT)
    fprintf("\t%d \t (%d, %d)", xT(i), T(i, 1), T(i, 2));
    if(xT(i) == 0 || xT(i) == cT(i, 2))
        fprintf(" | (Degenere)");
    elseif(xT(i) < 0 || xT(i) > cT(i, 2))
        fprintf(" | (NON AMMISSIBILE");
        if(xT(i) > cT(i, 2))
            fprintf(", portata %d", cT(i, 2));
        end
        fprintf(")");
    end
    fprintf("\n");
end

disp("xU: ");
for i = 1 : length(xU)
    fprintf("\t%d \t (%d, %d)\n", xU(i), U(i, 1), U(i, 2));
end

v = cT(:, 1)' * xT+ cU(:, 1)' * xU;
[p, k] = Potenziali(cT(:, 1), T, cL(:, 1), L, cU(:, 1), U, m);

fprintf("\n");
if(k(2) == -1)
    disp("Soluzione Ottima Trovata");
    disp("vO = ");
    disp(v);
else
    fprintf("Soluzione Non Ottima Attuale: %d\n", v);
    if(miglioramento ~= Inf)
        fprintf("Miglioramento rispetto al passo precedente: %d\n\n", miglioramento);
    end
end
end

function [xT, xL, xU] = baseAmmissibile(T, U, uU, b, n)
    disp("*************************************");    
    disp("* Verifico Ammissibilità della Base *");
    disp("*************************************");

    xT = zeros(n(1), 1);
    xL = zeros(n(2), 1);
    xU = uU;
    
    for i = 1 : size(U, 1)
        b(U(i, 1)) = b(U(i, 1)) + xU(i);
        b(U(i, 2)) = b(U(i, 2)) - xU(i);
    end
    
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

function [p, potDeg] = Potenziali(cT, T, cL, L, cU, U, m)
% p sono i potenziali
% potDeg(1) indica la riga dell'indice entrante k
% potDeg(2) indica se k viene da L (0) o da U(1) o soluzione ottima (-1)

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
    
    tmp = [L, zeros(size(L, 1), 1); U, ones(size(U, 1), 1)];
    
    cTmp = [cL; cU];
    [cTmp, tmp] = ordina(cTmp, tmp, []);

    potDeg = [0, -1];
    disp("Calcolo i costi ridotti");
    for i = 1 : size(tmp, 1)
        k = tmp(i, 1);
        l = tmp(i, 2);
        flag = tmp(i, 3);
        ckl = cTmp(i) - p(l) + p(k);
        fprintf("Arco (%d, %d) ", k ,l);
        if(flag)
            fprintf("[U] ");
        else
            fprintf("[L] ");
        end
        fprintf(": c = %d \t", ckl);
        if(ckl == 0)
            fprintf(" (Degenere) \t");
        end
        if((~flag && ckl < 0) || (flag && ckl > 0))
            fprintf("Base non Ammissibile");
            if(potDeg(2) == -1)
                potDeg = [i, flag];
            end
        end
        fprintf("\n");
    end
    
    if(potDeg(2) ~= -1)
        if(potDeg(2))
            % Inserisco da U
            potDeg(1) = find(U(:, 1) == tmp(potDeg(1), 1) & U(:, 2) == tmp(potDeg(1), 2));
        else
            % Inserisco da L
            potDeg(1) = find(L(:, 1) == tmp(potDeg(1), 1) & L(:, 2) == tmp(potDeg(1), 2));
        end
    end
    
end

function [cNew, Tnew, xNew] = ordina(c, T, x)
    ended = 0;
    if(isempty(c))
        c = zeros(size(T, 1), 2);
    end
    if(isempty(x))
        x = c(:, 1);
    end
    while ~ended
        ended = 1;
        for i = size(T, 1) : -1: 2
            if(T(i, 1) < T(i - 1, 1))
                ended = 0;
                T([i, i-1], :) = T([i-1, i], :);
                c([i, i-1], :) = c([i-1, i], :);
                x([i, i-1]) = x([i-1, i]);
            elseif((T(i, 1) == T(i - 1, 1)) && (T(i, 2) < T(i - 1, 2)))
                ended = 0;
                T([i, i-1], :) = T([i-1, i], :);
                c([i, i-1], :) = c([i-1, i], :);
                x([i, i-1]) = x([i-1, i]);
            end
        end

    end
    
    cNew = c;
    Tnew = T;
    xNew = x;
end

function [cT, T, xT, cL, L, xL, cU, U, xU, miglioramento] = simplessoCore(cT, T, xT, cL, L, xL, cU, U, xU, k, p)
% k(1) indica la riga
% k(2) indica la matrice L (0) o U (1)
    fprintf("\n\n*********************************************\n");
    disp("* Applico l'algoritmo del Simplesso su Reti *");
    disp("*********************************************");
    
    fprintf("\n Arco entrante k da ");
    
    if(k(2))
        fprintf("U");
        kVett = U(k(1), :);
    else
        fprintf("L");
        kVett = L(k(1), :);
    end
    
    fprintf(": (%d, %d)\n\n", kVett(1), kVett(2));



    % Funzione ricorsiva
    % T costante
    % il primo elemento è quello al quale voglio arrivare
    % il secondo quello dal quale parto
    [C_disc, C_conc] = ricercaCicli(T, kVett(1), kVett(2));
    
    C_conc = [kVett; C_conc];

    if(k(2))
        % Inserico da U
        Cpos = C_disc;
        Cneg = C_conc;        
    else
        % Inserisco da L
        Cpos = C_conc;
        Cneg = C_disc;
    end
    
    [~, Cpos] = ordina([], Cpos, []);
    [~, Cneg] = ordina([], Cneg, []);

    disp("C+: ");
    disp(Cpos);
    disp("C-:");
    disp(Cneg);
    
    if(k(2))
        % Se inserisco da U
        T = [T; U(k(1), :)];
        cT = [cT; cU(k(1), :)];
        xT = [xT; xU(k(1))];
    
        U(k(1), :) = [];
        cU(k(1), :) = [];
        xU(k(1)) = [];
        
    else
        % Se inserisco da L
        T = [T; L(k(1), :)];
        cT = [cT; cL(k(1), :)];
        xT = [xT; xL(k(1))];
    
        L(k(1), :) = [];
        cL(k(1), :) = [];
        xL(k(1)) = [];
    end
    
    % Temporaneo finché non trovo theta
    miglioramento = (cT(length(cT)) - p(kVett(2)) + p(kVett(1)));
    
    [cT, T, xT] = ordina(cT, T, xT);
    
    % Cerco in Cneg
    minimoNeg = [Inf, -1];
    for i = 1 : size(Cneg, 1)
        indice = any(T == Cneg(i, 1), 2) & any(T == Cneg(i, 2), 2);
        indice = find(indice == 1);

        th = xT(indice);

        fprintf("C- : Theta arco (%d, %d): %d\n", Cneg(i, 1), Cneg(i, 2), th);
        if(minimoNeg(1) > th || (minimoNeg(1) == th && indice < minimoNeg(2)))
            minimoNeg = [th, indice];
        end
    end
    
    % Cerco in Cpos
    minimoPos = [Inf, -1];
    for i = 1 : size(Cpos, 1)
        indice = any(T == Cpos(i, 1), 2) & any(T == Cpos(i, 2), 2);
        indice = find(indice == 1);

        th = cT(indice, 2) - xT(indice);    % u_ij - x_ij
        
        fprintf("C+ : Theta arco (%d, %d): %d\n", Cpos(i, 1), Cpos(i, 2), th);
        if(minimoPos(1) > th || (minimoPos(1) == th && indice < minimoPos(2)))
            minimoPos = [th, indice];
        end
    end

    fprintf("theta = min{%d [th-], %d [th+]} = ", minimoNeg(1), minimoPos(1));
    
    if((minimoNeg(1) < minimoPos(1)) || (minimoNeg(1) == minimoPos(1) && minimoNeg(2) < minimoPos(2)))
        minimo = [minimoNeg, 0];    % Uscente in L
    else
        minimo = [minimoPos, 1];    % Uscente in U
    end

    
    th = minimo(1);
    h = minimo(2:3);     % h(2) vale 0 se va in L, 1 se va in U
    clear minimoPos minimoNeg minimo
    
    hVett = [T(h(1), 1), T(h(1), 2)];
    fprintf("%d\n", th);
    fprintf("Arco Uscente h in ");

    % Il costo ridotto lo calcolo sull'arco entrante
    % che ho messo temporaneamente in fondo a cT
    if(k(2))
        % Se vengo da U
        miglioramento = -(th  * miglioramento);
    else
        % Se vengo da L
        miglioramento = +(th  * miglioramento);
    end
    
    if(h(2))
        % Va in U
        fprintf("U");
    else
        % Va in L
        fprintf("L");
    end

    fprintf(": (%d, %d)\n\n", hVett(1), hVett(2));
    
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
    
    if(h(2))
        % Se va in U
        U = [U; T(h(1), :)];
        cU = [cU; cT(h(1), :)];
        xU = [xU; xT(h(1))];
    
        T(h(1), :) = [];
        cT(h(1), :) = [];
        xT(h(1)) = [];
    else
        % Se va in L
        L = [L; T(h(1), :)];
        cL = [cL; cT(h(1), :)];
        xL = [xL; xT(h(1))];
    
        T(h(1), :) = [];
        cT(h(1), :) = [];
        xT(h(1)) = [];
    end
    
    

    [cT, T, xT] = ordina(cT, T, xT);
    [cL, L, xL] = ordina(cL, L, xL);
    [cU, U, xU] = ordina(cU, U, xU);
end

function [C_disc, C_conc, upd] = ricercaCicli(Tora, endPoint, startPoint)
% upd serve per comunicare a quello prima se ho fatto cambiamenti o meno
    upd = 0;
    C_disc = [];
    C_conc = [];
    rowPlus = find(Tora(:, 1) == startPoint);
    if(~isempty(rowPlus))
        endPlus = Tora(rowPlus, 2);
        tmp = Tora(rowPlus, :);
        Tora(rowPlus, :) = [];
    
        for i = 1 : length(endPlus)
            if(endPlus(i) == endPoint)
                C_conc = [C_conc; tmp(i, :)];
                upd = 1;
                return;
            end
            [C_disc, C_conc, upd] = ricercaCicli(Tora, endPoint, endPlus(i));
            if(upd)
                C_conc = [C_conc; tmp(i, :)];
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
                C_disc = [C_disc; tmp(i, :)];
                upd = 1;
                return;
            end
            [C_disc, C_conc, upd] = ricercaCicli(Tora, endPoint, endMinus(i));
            if(upd)
                C_disc = [C_disc; tmp(i, :)];
                upd = 1;
                return;
            end
        end
    end

end