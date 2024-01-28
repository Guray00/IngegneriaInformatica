function x = risolvi(A,b,base)
% risolve un sistema del tipo Ax = b. Se viene inserita una base allora
% considera solo le righe di base
[m, n] = size(A);
    
    if numel(b) ~= m
        error('A e b incompatibili.');
    end
    if ~isempty(base)
        b = b(base);
        disp(b);
        A = A(base,:);
        disp(A);
    end

    x = linsolve(A,b.');

end

