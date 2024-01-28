function y = soluzione_complementare(c_duale,A,b,x)
% data una soluzione di base "x" di un sistema "Ax <= b" la funzione trova
% la soluzione duale "yA^T = c". Ricordarsi di utilizzare "-c" utilizzato
% nel primale

% prima di tutto troviamo la base che genera x
% data la base troviamo Ab
% troviamo Ab^-1
%troviamo yb = c*Ab^-1
%riempiamo y con zeri e mettiamo nelle posizioni di base yb
  [m, n] = size(A);
  c = c_duale;
    
    if numel(b) ~= m
        error('A e b incompatibili.');
    end
    
    if numel(c) ~= n
        error('A e c incompatibili.');
    end
    
    if numel(x) ~= n
        error('A e x incompatibili.');
    end

    base = trova_base(A,x,b)
    yb = c*inv(matrice_base(A, base));
    y = zeros(1,m);

    for i = 1 : length(yb)
        y(base(i)) = yb(i);
    end

    if ~all(yb >= 0)
        fprintf('Soluzione duale non ammissibile in quanto esistono componenti negative.');
    end

end

