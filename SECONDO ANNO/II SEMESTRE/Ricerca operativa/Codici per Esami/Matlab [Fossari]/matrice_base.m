function result = matrice_base(A,base)
    %crea una matrice di base utilizzando le righe di una matrice A
    %relative e selezioanndo quelle relative alle componenti non nulle di
    %un vettore di base "base"
    [~, n] = size(A);
    n_base = nnz(base);
    % se ci sono troppe poche righe di base comunicalo
    if(n_base < n)
        fprintf('La base contiene meno di %d componenti.\n', n);
    end
    % se ci sono troppe righe di base riducile
    if(n_base > n)
        fprintf('La base è degenere: ridotte %d righe.\n', n_base - n);
        n_base = n;
    end
    sel = base(1:n_base);
    result = A(sel, :);
end