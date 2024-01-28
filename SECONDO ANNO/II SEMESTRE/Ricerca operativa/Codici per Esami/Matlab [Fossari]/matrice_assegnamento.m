function A = matrice_assegnamento(m,n)
% crea automaticamente una matrice dell'assegnamento realtiva ad un vettore
% di costi, visto come una matrice m*n.
A = zeros(m + n,n*n);
for i = 1: m
    for j = (i - 1)*n + 1 : i*n
        A(i,j) = 1;
    end
end
for i = m + 1: (m + n)
    for j = i - m : m : m * n
        A(i,j) = 1;
    end
end
end


