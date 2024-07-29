function d = mydet2(A)
n = size(A, 1);
for j=1:n-1
	if A(j, j) == 0
		error('ho incontrato un pivot nullo')
	end
	for i=j+1:n	
		lij = A(i, j)/A(j, j); % moltiplicatore (i,j)
		A(i, j:end) = A(i, j:end) - lij * A(j, j:end);
	end
end
d = prod(diag(A)); % Estraggo la diagonale di A con diag, e faccio il prodotto di tutti gli elementi con prod
end
