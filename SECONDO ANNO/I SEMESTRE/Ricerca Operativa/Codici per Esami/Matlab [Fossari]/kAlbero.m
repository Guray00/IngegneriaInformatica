function tree = kAlbero(A,root,not_take,must_take)
% Questa funzione fa da wrapper alla funzione "ktree" (non creata da me). Inserisci in "not_take" gli archi che non vuoi prendere nella creazione del kalbero ed in "must_take" quelli che devi per forza prendere.

% NOTA: questa funzione è pensata per risolvere problemi di Branch & Bound per TSP simmetrico passo passo.

% NOTA: Se appare il messaggio "Qualcosa è andato storto" vi viene allegato
%  un "costo di debug": se questo è dell'ordine dei milioni allora non è
%  stato possibile creare un kalbero senza gli archi in "not_take".
%  Viceversa, se è dell'ordine dei 10^(-6) ed il milionesimo valore è
%  diverso dal numero di archi in "must_take", allora almeno un arco in
%  "must_take" non è stato preso.

realA = A;
[m n] = size(not_take);
if ~isempty(not_take) && n ~= 2
    error("Vogliamo che not_take abbia 2 colonne");
end
for i = 1 : m
    A(not_take(i,1),not_take(i,2)) = 1e6;
end
[m n] = size(must_take);
if ~isempty(must_take) && n ~= 2
    error("Vogliamo che not_take abbia 2 colonne");
end
for i = 1 : m
    A(must_take(i,1),must_take(i,2)) = 1e-6;
end
disp('Nuovi costi:');
disp(A);
g = graph(A, string(1:length(A)), "upper");
    [tree, costoreale] = ktree(g, root);
    p = plot(g);
    highlight(p, tree);
    costo = 0;
    r= size(tree.Edges,1);
    for i = 1 : r
        row = str2double(cell2mat(tree.Edges.EndNodes(i,1)));
        col = str2double(cell2mat(tree.Edges.EndNodes(i,2)));
        costo = costo + realA(row,col);
    end
    fprintf('Costo k-albero: %d.',costo);
    if costoreale >= 1e6 || abs((1e-6 * m)-(costoreale - floor(costoreale))) >= 1e-6
        fprintf('Qualcosa potrebbe essere andato storto. Costo di debug: %f.',1e-6 * m - ((costoreale - floor(costoreale))));
    end
    fprintf('\n');
end

