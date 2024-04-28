function [E,c,u] = M2E(M)
% Data una matrice che descrive una rete M ri righe [i j c u], genera la matrice di incidenza E ed i vettori c ed u per una rete capacitata.
[m n] = size(M);
for i = 1 : m
    E(M(i,1),i) = -1;
    E(M(i,2),i) = 1;
    c(1,i) = M(i,3);
    u(1,i) = M(i,4);
end
end