function [c,int,A,b,Aeq,beq,lb,ub] = bin_packing(p,Cap,n_greedy)
%crea [c,int,A,b,Aeq,beq,lb,ub] da utilizzare con intlinprog partendo dai pesi "p", la capacità dei contenitori "Cap" ed il numero di contenitori "n_greedy" ottenuto in maniera greedy
% m oggetti, n contenitori
[n m] = size(p);
if n>1
    error('P deve essere un vettore riga');
end
n = n_greedy;

c = zeros(1,m*n+n);
c(n*m+1:n*m+n)= 1;
beq = 1 + zeros(1,m);
b = zeros(1,n);
Aeq = zeros(m,m*n+n);
A = zeros(n,n*m+n);
int = 1:(m*n+n);
lb = zeros(m*n+n,1);
ub = 1+zeros(m*n+n,1);

    for i = 1:n
        Aeq(1:m,(i-1)*m+1:(i-1)*m+m) = eye(m);
    end
    for i = 1 : n
        A(i,(i-1)*m+1:(i-1)*m+m) = p(1:m);
    end
    A(1:n,m*n+1:m*n+n) = -Cap*eye(n);
end

