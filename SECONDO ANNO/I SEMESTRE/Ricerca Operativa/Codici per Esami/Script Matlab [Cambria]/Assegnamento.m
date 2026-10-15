function [Aeq, beq, lb] = Assegnamento(n)
%Inizializza Aeq, beq e lb per un problema di assegnamento a n variabili

if(n <= 0)
    disp("Entra un numero sensato bro");
else
    lb = zeros(n*n, 1);
    beq = ones(2*n, 1);
    
    Aeq = zeros(2*n, n*n);
    
    for i = 1 : n
        k = (i-1)*n;
        for j = 1:n
            Aeq(i, k+j) = 1;
        end
    end

    for i = 1 : n
        for j = 1 : n
            Aeq(n+i, i + n*(j-1)) = 1;
        end
    end
end
end

