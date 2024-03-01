%% Algoritmo del simplesso dei cammini minimi
% Written by AndJ

function shortest_path_tree(H,source)
% H è la matrice del grafo con nodo_s nodo_t capacità a ogni riga
% n° di righe pari al n° degli archi

% Esempio di input (archi 12 13 24 32 34 35 45 46 56)
% Costo 8 7 2 4 1 3 11 9 4 (ordine lessicografico)

% s = [1 1 2 3 3 3 4 4 5];
% t = [2 3 4 2 4 5 5 6 6];
% weights = [8 7 2 4 1 3 11 9 4];


G = digraph(H(:,1),H(:,2),H(:,3));

TR = shortestpathtree(G,source);

% x = [-0.7, 0, 0, 1, 1, 1.7];
% y = [sqrt(3)/2, sqrt(3), 0, sqrt(3), 0, sqrt(3)/2];

p = plot(G,'EdgeLabel',G.Edges.Weight,LineWidth=2,ArrowSize=20);
p.MarkerSize = 7;
p.EdgeFontSize=20;
p.NodeFontSize=20;
highlight(p,TR,'EdgeColor','r', LineWidth=5)

set(gca, 'XTick', []);
set(gca, 'YTick', []);

title('Graph Plot');

end