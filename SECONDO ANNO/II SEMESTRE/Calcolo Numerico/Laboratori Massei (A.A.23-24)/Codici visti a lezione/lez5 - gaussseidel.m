function x = gaussseidel(A, b, k)
%GAUSSSEIDEL Soluzione di un sistema lineare usando il metodo di Gauss-Seidel.
%
% X = GAUSSSEIDEL(A, B, K) risolve il sistema lineare AX = B usando il metodo di
%     Gauss-Seidel sulla matrice A. Vengono effettuate esattamente K iterazioni.

m = size(A, 1);
n = size(A, 2);

if m ~= n
    error('La matrice A non è quadrata');
end

if size(b, 1) ~= n
    error('Il vettore b non ha dimensioni compatibili con A');
end

x = b;

for j = 1 : k
    % Iterazione j
    
    for i = 1 : n        
        % Questa e le istruzioni seguenti sono scritte per funzionare anche
        % quando b ha più colonne, e dunque vengono risolti più sistemi
        % lineari in un colpo solo. 
        x(i, :) = b(i, :);
        
        for s = 1 : n
            if s ~= i
                x(i, :) = x(i, :) - A(i, s) * x(s, :);
            end
        end
        x(i, :) = A(i,i) \ x(i, :);
    end
    
    % Stampiamo il residuo
    norm(A * x - b)
end
