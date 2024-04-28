%% Max flow
% Written by AndJ

function max_flow(H, source, sink)
% H è la matrice del grafo con nodo_s nodo_t capacità a ogni riga
% n° di righe pari al n° degli archi

% Esempio di input (archi 12 13 24 25 34 46 56)
% Capacità 4 5 2 6 3 4 5 (ordine lessicografico)

% s = [1 1 2 2 3 4 5];
% t = [2 3 4 5 4 6 6];
% weights = [4 5 2 6 3 4 5];

G = digraph(H(:,1),H(:,2),H(:,4));
% G = digraph(s,t,weights);

% x = [-0.7, 0, 0, 1, 1, 1.7];
% y = [sqrt(3)/2, sqrt(3), 0, 0, sqrt(3), sqrt(3)/2];

p = plot(G,'EdgeLabel',G.Edges.Weight,LineWidth=2,ArrowSize=20);
p.MarkerSize = 7;
p.EdgeFontSize=20;
p.NodeFontSize=20;

[mf,GF,cs,ct] = maxflow(G,source,sink,'augmentpath');

p.EdgeLabel = {};
highlight(p,GF,'EdgeColor','r','LineWidth',2);
st = GF.Edges.EndNodes;
labeledge(p,st(:,1),st(:,2),GF.Edges.Weight);

x=[GF.Edges.EndNodes, GF.Edges.Weight ;H(:,1),H(:,2), zeros(length(H),1)];

% x = unique(x,'rows','last');
% x = sortrows(x,[1 2]);

% Extract columns 1 and 2 for comparison
columns_to_compare = x(:, 1:2);

% Find unique rows based on columns 1 and 2
[unique_rows, ~, idx] = unique(columns_to_compare, 'rows');

% Use the indices to extract corresponding values from the third column
x = [unique_rows, accumarray(idx, x(:, 3), [], @max)];

%disp(GF.Edges)

disp('Soluzione "x"')
disp(x(:,3)')

disp("Valore del flusso massimo")
disp(mf)

disp('Ns')
disp(cs')
disp('Nt')
disp(ct')

end