function M = cost2TSP(costi,nodi)
% trasforma un vettore di costi in forma matriciale, come utilizzata dalle altre funzioni TSL
M = zeros(nodi:nodi);
quanti = nodi - 1;
iter = 1;
for i = 1 : nodi - 1
    M(i,i+1:nodi) = costi(1,iter:iter + quanti - 1);
    iter = iter + quanti;
    quanti = quanti - 1;
end
end

