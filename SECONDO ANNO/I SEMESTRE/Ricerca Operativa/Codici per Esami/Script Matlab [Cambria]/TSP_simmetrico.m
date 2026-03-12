function [vI, vS] = TSP_simmetrico(c, n, K, S)
%Restituisce le valutazioni di PLI Dato il vettore dei costi
%   c: vettore riga che contiene i costi in ordine ((1,2), ..., (1,n), (2,3), ... (n-1, n))
%   x_ij -> Viaggio i <--> j
%   k: indice k-albero
%   s: primo nodo per il nodo più vicino

if(length(c) ~= (n*n - n)/2 || K < 0 || K > n || S < 0 || S > n)
    disp("Numeri sensati bro");
else
    C = Inf * ones(n-1);
    k = 1;
    for i = 1 : n-1
        for j = i : n-1
            C(i, j) = c(k);
            k = k+1;
        end
    end
    disp("Matrice dei costi: ");
    disp(C);
    
    
    vI = k_albero(C, n, K);
    vS = nextNode(C, n, S);
    
    if(vI == vS)
        fprintf("v = vI = vS = %d \n\n", vI);
    else
        fprintf("v in [%d, %d] \n\n", vI, vS);
    end

end
end


function v = k_albero(C, n, k)
    v = 0;
    disp("Calcolo Valutazione Inferiore");
    
    Ctmp = C;
    
    if(k < n && k > 1)
        Ctmp(k, :) = Inf;
        Ctmp(:, k-1) = Inf;
    elseif k == n
        Ctmp(:, k-1) = Inf;
    else
        Ctmp(k, :) = Inf;
    end
    
    taken = [];
    for archi = 1 : n - 2
        good = 0;
        while ~good
            good = 0;
            [minimo, indice] = min(Ctmp, [], "all");
            Ctmp(indice) = Inf;
            y = floor((indice - 1)/(n-1));
            x = indice - y *(n-1);
            
            y = y + 2;
            
            if(~createsCycles(taken, y, x))
                taken = [taken; x y];
                good = 1;
            end
        end
        fprintf("Arco: %d - %d \t|\t Aggiungo %d\n", x, y, minimo);
        v = v + minimo;
    end

    if(k < n && k > 1)
        tmp1 = C(k, :);
        [v1, I1] = sort(tmp1);
        tmp2 = transpose(C(:, k-1));
        [v2, I2] = sort(tmp2);
        
        for j = 1 : 2
            if(v1(1) <= v2(1))
                valore(j) = v1(1);
                v1(1) = [];
                x(j) = k;
                y(j) = I1(1) + 1;
                I1(1) = [];
            else
                valore(j) = v2(1);
                v2(1) = [];
                x(j) = I2(1);
                I2(1) = [];
                y(j) = k;
            end
        end

        clear v1 v2 I1 I2;

    elseif k == n
        Ctmp  = transpose(C(:, k-1));
        [valore, I] = sort(Ctmp);
        valore = valore(1:2);
        y = [k, k];
        x = I(1:2);

        clear I;
    else
        Ctmp = C(k, :);
        [valore, I] = sort(Ctmp);
        valore = valore(1:2);
        x = [k, k];
        y = I(1:2);
        clear I;
    end
    
    for i = 1 : 2
        fprintf("Arco: %d - %d \t|\t Aggiungo %d\n", x(i), y(i), valore(i));
        v = v + valore(i);
    end
    
    fprintf("vI = %d \n\n", v);
end

function v = nextNode(C, n, s)
    v = 0;
    Cfixed = C;
    og = s;
    disp("Calcolo Valutazione Superiore");
    for archi = 1 : 4
        if(s < n && s > 1)
            [n1, y] = min(C(s, :), [], 'all');
            [n2, x] = min(C(:, s-1), [], 'all');
            
            C(s, :) = Inf;
            C(:, s-1) = Inf;
            if(n1 < n2)
                costo = n1;
                x = s;
            else
                costo = n2;
                y = s - 1;
            end
            clear n1 i1 n2 i2;
            
        elseif s == n
            [costo, x] = min(C(:, s-1));
            y = s - 1 ;
            C(:, s-1) = Inf;
        else
            [costo, y] = min(C(s, :));
            x = s;
            C(s, :) = Inf;
        end
        y = y + 1;

        fprintf("Arco: %d - %d \t|\t Aggiungo %d\n", x, y, costo);
        v = v + costo;

        if s ~= x
            s = x;
        else
            s = y;
        end
    end
    
    if(og < s)
        x = og;
        y = s-1;
    else
        x = s;
        y = og - 1;
    end

    costo = Cfixed(x, y);
    
    fprintf("Arco: %d - %d \t|\t Aggiungo %d\n", x, y+1, costo);
    v = v + costo;
    
    fprintf("vS = %d \n\n", v);
    
end

function [b] = createsCycles(T, endPoint, startPoint)
    b = 0;
    
    if(isempty(T) || all(T(:, 1) == Inf))
        return
    end
    Tcopia = T;

    row = find(T(:, 1) == startPoint);
    
    for i = 1 : length(row)
        newStart = T(row(i), 2);
        T(row(i), :) = Inf;
        if(newStart == endPoint)
            b = 1;
            return
        end
        b = createsCycles(T, endPoint, newStart);
    end
    if(b)
        return;
    end

    row = find(Tcopia(:, 2) == startPoint);
    for i = 1 : length(row)
        newStart = Tcopia(row(i), 1);
        Tcopia(row(i), :) = Inf;
        if(newStart == endPoint)
            b = 1;
            return
        end
        b = createsCycles(Tcopia, endPoint, newStart);
    end
end