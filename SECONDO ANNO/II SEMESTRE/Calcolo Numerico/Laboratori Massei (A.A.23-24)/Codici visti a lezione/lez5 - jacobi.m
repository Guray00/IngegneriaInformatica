function x = jacobi(A, b, k)
%JACOBI Soluzione di un sistema lineare usando il metodo di Jacobi.
%
% X = JACOBI(A, B, K) risolve il sistema lineare AX = B usando il metodo di
%     Jacobi sulla matrice A. Vengono effettuate esattamente K iterazioni.

m = size(A, 1);
n = size(A, 2);

if m ~= n
    error('La matrice A non è quadrata');
end

if size(b, 1) ~= n
    error('Il vettore b non ha dimensioni compatibili con A');
end

x = b;
x_new = zeros(n,1);
for j = 1 : k
    % Iterazione j
    
    
    for i = 1 : n        
        % Questa e le istruzioni seguenti sono scritte per funzionare anche
        % quando b ha più colonne, e dunque vengono risolti più sistemi
        % lineari in un colpo solo. 
        S = 0;
        
        for s = 1 : n
            if s ~= i
                S = S + A(i, s) * x(s, :);
            end
        end
        x_new(i, :) = (b(i, :)-S)/A(i,i);
    end
    
    x = x_new;
    
    % Stampiamo il residuo
    norm(A * x - b)
end
