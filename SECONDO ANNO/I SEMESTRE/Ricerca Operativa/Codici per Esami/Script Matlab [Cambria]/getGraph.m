function [G, c, u] = getGraph(T, L, U, cT, cL, cU)
% [G, c, u] : Data la tripartizione T,L,U e le portate/costo restituisce il grafo

if(size(T, 2) ~= 2 || size(L, 2) ~= 2 || size(U, 2) ~= 2 || ...
   size(cT, 2) ~= 2 || size(cL, 2) ~= 2 || size(cU, 2) ~= 2 || ...
   size(T, 1) ~= size(cT, 1) || size(L, 1) ~= size(cL, 1) || size(U, 1) ~= size(cU, 1))
    disp("Hai sbagliato qualcosa!");
end

G = [T; L; U];
c = [cT; cL; cU];

[c, G] = ordina(c, G);
u = c(:, 2);
c = c(:, 1);

end

function [cNew, Tnew] = ordina(c, T)
    ended = 0;
    if(isempty(c))
        c = zeros(size(T, 1), 2);
    end
    while ~ended
        ended = 1;
        for i = size(T, 1) : -1: 2
            if(T(i, 1) < T(i - 1, 1))
                ended = 0;
                T([i, i-1], :) = T([i-1, i], :);
                c([i, i-1], :) = c([i-1, i], :);
            elseif((T(i, 1) == T(i - 1, 1)) && (T(i, 2) < T(i - 1, 2)))
                ended = 0;
                T([i, i-1], :) = T([i-1, i], :);
                c([i, i-1], :) = c([i-1, i], :);
            end
        end

    end
    
    cNew = c;
    Tnew = T;
end