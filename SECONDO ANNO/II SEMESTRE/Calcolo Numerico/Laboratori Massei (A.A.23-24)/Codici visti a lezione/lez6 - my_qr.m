function [Q, R] = my_qr(A)
%MY_QR Calcola la fattorizzazione QR di A. 
%
% [Q, R] = MY_QR(A) calcola la fattorizzazione QR di A, utilizzando
%     riflettori di Householder.
%
% Questa implementazione funziona anche con matrici rettangolari. 

[m, n] = size(A);

R = A;
Q = eye(m);

% Riduciamo tutte le colonne in modo che siano triangolari superiori.
% Dobbiamo occuparci delle prime min(n, m - 1) colonne. 
for j = 1 : min(m - 1, n)
    % Calcolo un riflettore di Householder che mappa la parte restante
    % della colonne j-esima di R in un multiplo di e1.
    u = householder_vector(R(j:end, j));
    b = 2/norm(u)^2;
    % Lo applico ad R a sx, e a Q a dx.
    R(j:end,j:end) = R(j:end,j:end) - b * u * (u' * R(j:end,j:end));
    Q(:,j:end) = Q(:,j:end) - b * (Q(:,j:end) * u) * u';
    
    % Dato che R è triangolare superiore, la parte triangolare inferiore si
    % può impostare a zero manualmente, per evitare di vedere del round-off
    R(j+1:end,j) = 0;
end



end

