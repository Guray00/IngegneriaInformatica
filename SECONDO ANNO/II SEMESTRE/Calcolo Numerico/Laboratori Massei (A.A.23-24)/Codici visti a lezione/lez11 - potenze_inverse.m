function [z, lamvec] = potenze_inverse(A, z0, maxit)
	z = z0/norm(z0);
	lamvec = [];
	[L, U, p] = lu(A, 'vector');
	for j = 1:maxit
		y = U\(L\(z(p)));
		lamvec = [lamvec; 1/(z'*y)];
		z = y/norm(y);
	end
end
