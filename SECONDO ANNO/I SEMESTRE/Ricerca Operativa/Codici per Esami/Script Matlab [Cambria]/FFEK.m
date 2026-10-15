function [x, v] = FFEK(u, G, s, t, n)
% Le righe di u si riferiscono a quelle di G
% u: vettore colonna indica la portata massima di ogni arco
% G: matrice n x 2 che indica tutti gli archi (i, j) presenti
%   - G(:, 1) = nodo di partenza
%   - G(:, 2) = nodo di arrivo
% s: nodo di partenza
% t: nodo di arrivo
% n: nodi totali

if(isempty(u) || isempty(G) || ...
    size(G, 1) ~= size(u, 1) || ...
    size(G, 2) ~= 2 || size(u, 2) ~= 1 || ...
    s < 0 || s > n || ...
    t < 0 || t > n || ...
    n < 0 )
    disp("Numeri Sensati Bro");
end

[u, G] = ordina(u, G, []);
[x, v] = cammino(u, G, s, t);

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
                T([i, i-1], :) = T([i-1, i], :);
                c([i, i-1]) = c([i-1, i]);
                x([i, i-1]) = x([i-1, i]);
            end
        end

    end
    
    cNew = c;
    Tnew = T;
    xNew = x;
end

function print(m, r, G, x, v, s, t)
    disp("x: ");
    for i = 1 : m
        fprintf("\t%d\t(%d, %d)\t|\tResiduo: %d\n", x(i), G(i, 1), G(i, 2), r(i));
    end
    fprintf("v: %d\n\n", v);
    if(~isempty(s) && ~isempty(t))
        fprintf("s: %d\n", s);
        fprintf("t: %d\n\n", t);
    end
end


function [x, v] = cammino(u, G, start, termina)
m1 = size(G, 1);
x = zeros(m1, 1);
v = 0;

m = m1 * 2;
Gres = [G; G(:, 2), G(:, 1)];
r = [u; zeros(m1, 1)];
xRes = [x; zeros(m1, 1)];
[r, Gres, xRes] = ordina(r, Gres, xRes);




disp("**************************");
disp("* Situazione di partenza *");
disp("**************************");

print(m1, u, G, x, v, start, termina);

while 1
    % FS(:, 1) -> nodo i di partenza per arrivare
    % FS(:, 2) -> nodo j di arrivo
    % FS(:, 3) -> costo residuo
    % FS(:, 4) -> riga di xRes relativa all'arco (i, j)
    FS = [];
    k = 1;
    s = start;
    t = termina;

    while isempty(FS) || ~ismember(t, FS(:, 2))
        first = 1;
        disp("----|----");
        fprintf("%d\t|", s);
        for i = 1 : m
            if(Gres(i, 1) > s)
                break;
            end
            if(Gres(i, 1) == s && ...
                r(i) > 0 && ...
                (isempty(FS) || ~ismember(Gres(i, 2), FS(:, 2))) ...
                )
                if(~first)
                    fprintf(" \t|");
                end
                first = 0;
                fprintf("%d\n", Gres(i, 2));
                FS = [FS; Gres(i, :), r(i), i];
                
                if(Gres(i, 2) == t)
                    break;
                end
            end
        end

        
        if(isempty(FS) || k > size(FS, 1))
            fprintf("\n");
            disp("----|----");
            fprintf("FS vuoto\n\n");

            disp("****************************");
            disp("* SOLUZIONE OTTIMA TROVATA *");
            disp("****************************");

            print(m1, u-x, G, x, v, start, termina);
            return;
        end

        s = FS(k, 2);
        k = k + 1;   
        fprintf("\t|\n");
    end
    disp("----|----");
    

    


    Caum = t;
    for i = size(FS, 1): -1 : 1
        if(FS(i, 2) == Caum(1))
            Caum = [FS(i, 1), Caum];
        else
            FS(i, :) = [];
        end
    end
    
    delta = min(FS(:, 3));

    fprintf("\nCaum: "); disp(Caum);
    fprintf("δ: %d\n", delta);

    for i = 1 : size(FS, 1)
        xRes(FS(i, 4)) = xRes(FS(i, 4)) + delta;
        r(FS(i, 4)) = r(FS(i, 4)) - delta;
        rigaRitorno = (Gres(:, 1) == FS(i, 2) & Gres(:, 2) == FS(i, 1));
        r(rigaRitorno) = r(rigaRitorno) + delta;
    end
    v = v + delta;
    k = 1;

    print(m, r, Gres, xRes, [], []);

    for i = 1 : m
        if(Gres(i, 1) == G(k, 1) && Gres(i, 2) == G(k, 2))
            x(k) = xRes(i);
            k = k + 1;
            if(k > m1)
                break;
            end
        end
    end

    
end

end