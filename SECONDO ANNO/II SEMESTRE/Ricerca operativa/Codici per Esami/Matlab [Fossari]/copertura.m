function A = copertura(costi, limite)
% crea una matrice di copertura, dati i costi iniziali e il valore limite
[m n] = size(costi);
for i = 1: m 
    for j = 1 : n 
        if costi(i,j)>limite
            costi(i,j) = 0;
        else
            costi(i,j) = 1;
        end
    end
end
A = costi;
end

