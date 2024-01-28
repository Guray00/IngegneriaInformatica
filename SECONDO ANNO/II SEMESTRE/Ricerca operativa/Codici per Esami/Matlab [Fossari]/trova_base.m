% questa funzione prova a ricercare la base relativa ad una certa soluzione
% x è un vettore colonna n*1, A è m*n e b è vettore riga 1*m
function base = trova_base(A, b, x)
    %A può avere qualsiasi dimensione
    %x vettore colonna con tante righe quante sono le colonne di A
    %b deve avere le stesse dimensioni di x
    dimx = size(x);
    dimA = size(A);
    dimb = size(b);
    tolerance = 1e-6;

    % serve x n*1 e A m*n
    if dimx(1) ~= dimA(2) || dimx(2) ~= 1
        fprintf('A*x con dimensioni incompatibili (%d * %d)*(%d * %d)\n',dimA(1),dimA(2),dimx(1),dimx(2));
        return;
    end

    %serve b m*1
    if dimb(1) ~= 1 || dimA(1) ~= dimb(2)
        fprintf('A*x e b hanno dimensioni incompatibili (%d * %d)*(%d * %d)\n',dimx(1),dimx(2),dimb(1),dimb(2));
        return;
    end

    result = b - ((A * x).');
    fprintf("b - A*x : ");
    disp(result);

    fprintf('Se x fosse vertice ci aspetteremmo una base di dimensione %d\n',dimx(1));
    fprintf('Base relativa ad x:');
    j = 1;
    base = [];
    for i = 1:length(result)
        if abs(result(i)) <= tolerance
            base(j) = i;
            j = j + 1;
        end
    end
    if isempty(base)
        fprintf('\n');
        error('Non è soluzione di base.');
    end
    disp(base);
end
