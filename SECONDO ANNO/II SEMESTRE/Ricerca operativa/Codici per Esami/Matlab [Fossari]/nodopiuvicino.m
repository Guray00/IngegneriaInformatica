function tot = nodopiuvicino(c, root)
% applica nodo più vicino ad una rete "c" partendo da "root"
[m n] = size(c);
if m ~= n
    error('La tabella dei costi deve essere quadrata');
end
 s = root;
 percorso(1) = s;
% per ogni riga (ovvero ogni nodo)
% cerca la colonna contenente il valore minimo
% cerca lo stesso nella colonna di indice pari alla riga
% serve un altro for per scorrere la colonna
for i = 1 : n - 1
    min = 1e6;
    for j = 1 : n
        if j == s
            continue
        end
        if c(s,j) > 0 && c(s,j) < min && ~ismember(j,percorso)
            min = c(s,j);
            d = j;
        end
        if c(j,s) > 0 && c(j,s) < min && ~ismember(j,percorso)
            min = c(j,s);
            d = j;
        end
    end
    percorso(1,i + 1) = d;
    costo(1,i) = min;
    s = d;
end
percorso(1,n + 1) = root;
if c(s,root) == 0
    costo(1,n) = c(root,s);
else 
    costo(1,n) = c(s,root);
end
for i = 1 : n
    fprintf ('%d|--%d->|',percorso(i),costo(i));
end
fprintf('%d',root);
tot = sum(costo);
end