function [A, b, lb] = Trasporto(d, o)
% Inizializza A, b e lb per un problema di trasporto con domanda d e offerta o

if(isrow(d))
    d = d';
end
if(isrow(o))
    o = o';
end

n = length(d);
m = length(o);

lb = zeros(n*m, 1);
b = [o ; -d];

for i = 1 : n
    k = (i-1)*n;
    for j = 1:n
        A(i, k+j) = 1;
    end
end

for i = 1 : n
    for j = 1 : n
        A(n+i, i + n*(j-1)) = -1;
    end
end
end
