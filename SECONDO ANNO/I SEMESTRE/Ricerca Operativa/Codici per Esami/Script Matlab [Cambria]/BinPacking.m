function [c, A, b, Aeq, beq, lb, ub, x, v, flag] = BinPacking(p, P, m, intero)
%Inizializzo le variabili del problema dati (x_scatola,oggetto)
%   p: vettore riga dei pesi
%   m: numero di contenitori y
%   P: dimensione massima di un contenitore
%   intero:
%       - ~: intlinprog
%       - 1: next-fit-decreasing
%       - 2: first-fit-decreasing
%       - 3: best-fit-decreasing

    disp("Il formato è che ogni variabile x_ij indica:");
    disp(" - i: contenitore dove è contenuto");
    disp(" - j: oggetto");
    
    n = length(p);
    c = zeros(1, n*m + m);
    A = zeros(m, n*m + m);
    b = zeros(m, 1);
    Aeq = zeros(n, n*m + m);
    beq = ones(n, 1);
    lb = zeros(n*m + m, 1);
    ub = ones(n*m + m, 1);
    Pmax = P;


    for i = n*m +1 : n*m + m
        c(i) = 1;
    end
    
    for i = 1 : n
        for j = 1 : m
            Aeq(i, i + (j-1)*n) = 1;
        end
    end

   
    for i= 1 : m
        for j = 1 : n
            A(i, j + (i-1)*n) = p(j);
        end
        A(i, n*m + i) = -P;
    end
    
    [x, v, flag] = linprog(c, A, b, Aeq, beq, lb, ub);

    switch(intero)
        case 1
            [vI, vS] = next_fit_decreasing(p, Pmax, m, v);
        case 2
            [vI, vS] = first_fit_decreasing(p, Pmax, m, v);
        case 3
            [vI, vS] = best_fit_decreasing(p, Pmax, m, v);
        otherwise
            intero = 0;
            [x, v, flag] = intlin(c, A, b, Aeq, beq, lb, ub);
    end

    if(intero)
        if(vI == vS)
            fprintf("\n\tvI = vS = v = %d\n\n", vI);
        else
            fprintf("\n\tv in [%d, %d]\n\n", vI, vS);
        end
    end
end

function [vI, vS] = next_fit_decreasing(p, P, m, v)
% Se sta nell'ultimo aperto lo metto, altrimenti chiudo e passo a quello
% dopo
    [p_sort, i_sort] = sort(p, 'descend');
    n = length(p_sort);
    
    disp("Vettore ordinato: ");
    disp(p_sort);
    disp("Indici: ");
    disp(i_sort);
    
    vI = ceil(v);
    y = zeros(m, n);
    strido = P;
    j = 1;
    for i = 1: length(p_sort)
        if(p_sort(i) <= strido)
            strido = strido - p_sort(i);
            y(j, i_sort(i)) = 1;
            
            fprintf("Contenitore %d | ", j);
            fprintf("Oggetto %d | ", i_sort(i));
            fprintf("Peso %d | ", p_sort(i));
            fprintf("Strido %d |\n", strido);
        else
            j = j + 1;
            strido = P - p_sort(i);
            y(j, i_sort(i)) = 1;
            
            fprintf("Contenitore %d | ", j);
            fprintf("Oggetto %d | ", i_sort(i));
            fprintf("Peso %d | ", p_sort(i));
            fprintf("Strido %d |\n", strido);
        end
        if(j > m)
            fprintf("Contenitori non sufficenti, mancano gli oggetti:");
            disp(p_sort(i+1:length(p_sort)));
            break;
        end
    end

    vS = j;
end


function [vI, vS] = first_fit_decreasing(p, P, m, v)
% Inserisco nel primo aperto dove c'è abbastanza spazio, altrimenti ne apro
% uno nuovo
    [p_sort, i_sort] = sort(p, 'descend');
    n = length(p_sort);
    
    disp("Vettore ordinato: ");
    disp(p_sort);
    disp("Indici: ");
    disp(i_sort);
    
    vI = ceil(v);
    y = zeros(m, n);
    strido = P * ones(m, 1);
    for i = 1: length(p_sort)
        for j = 1 : m
            if(p_sort(i) <= strido(j))
                strido(j) = strido(j) - p_sort(i);
                y(j, i_sort(i)) = 1;
                
                fprintf("Contenitore %d | ", j);
                fprintf("Oggetto %d | ", i_sort(i));
                fprintf("Peso %d | ", p_sort(i));
                fprintf("Strido %d |\n", strido(j));
                break;
            end
        end   
    end
    
    unused = strido == P;
    unused(unused == 0) = [];
    vS = m - length(unused);
end


function [vI, vS] = best_fit_decreasing(p, P, m, v)
% Inserisco in quello con il più piccolo strido sufficente a far entrare
% l'oggetto. altrimenti ne apro uno nuovo
    [p_sort, i_sort] = sort(p, 'descend');
    n = length(p_sort);
    
    disp("Vettore ordinato: ");
    disp(p_sort);
    disp("Indici: ");
    disp(i_sort);
    
    vI = ceil(v);
    y = zeros(m, n);
    strido = P * ones(m, 1);
    for i = 1: length(p_sort)
        [strido_sort, j_sort] = sort(strido, 'ascend');
        for j = 1 : m
            if(p_sort(i) <= strido_sort(j))
                strido_sort(j) = strido_sort(j) - p_sort(i);
                y(j_sort(j), i_sort(i)) = 1;
                
                fprintf("Contenitore %d | ", j_sort(j));
                fprintf("Oggetto %d | ", i_sort(i));
                fprintf("Peso %d | ", p_sort(i));
                fprintf("Strido %d |\n", strido_sort(j));
                break;
            end
        end
        strido(j_sort) = strido_sort;
    end
    
    unused = strido == P;
    unused(unused == 0) = [];
    vS = m - length(unused);
end

function [x, v, flag] = intlin(c, A, b, Aeq, beq, lb, ub)
    I = ones(1,length(c));
        for i = 1 : length(I)
            I(i) = i;
        end
    [x, v, flag] = intlinprog(c, I, A, b, Aeq, beq, lb, ub, optimoptions('intlinprog', 'Display', 'off'));
end