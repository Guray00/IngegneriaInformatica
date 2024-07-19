function [U, c] = my_gauss(A, b)
n = size(A, 1);
Ab = [A, b]; % costruisco la matrice aumentata
for j=1:n-1
	for i=j+1:n
		lij = Ab(i, j)/Ab(j, j); % moltiplicatore (i,j)
		Ab(i, j:n+1) = Ab(i, j:n+1) - lij * Ab(j, j:n+1);
	end
	Ab(j+1:n, j) = 0; % Metto a zero la parte sotto la diagonale della colonna j	
end
U = Ab(:, 1:n);
c = Ab(:, n+1);
end
