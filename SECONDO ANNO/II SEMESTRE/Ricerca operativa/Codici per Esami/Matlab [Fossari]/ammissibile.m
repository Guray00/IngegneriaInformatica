function [violated] = ammissibile(A, b, x)
% controlla che la soluzione "x" di un sistema Ax <= b sia ammissibile. Se
% non lo è ritorna la base violata

    % Check the dimensions of input matrices
    [m, n] = size(A);
    b = b.';
    
    % Check if the dimensions are consistent
    if size(b,1) ~= m || size(x,1) ~= n
        error('Dimensioni di A,x e b incompatibili.');
    end
    
    % Check admissibility
    Ax = A * x;
    diff = Ax - b;
    violated = find(diff > 0);
    if ~violated
        disp('Ammissibile.')
        return
    end
    disp('Vincoli violati:');
    for i = 1 : length(violated)
        fprintf('%f non è <= di %f\n',Ax(violated(i)),b(violated(i)));
    end
    violated = violated.';
end
