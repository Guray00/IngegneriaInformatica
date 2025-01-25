function [z, lamvec] = potenze(A, z0, maxit)
	z = z0/norm(z0);
	lamvec = [];
	for j = 1:maxit
		y = A * z;
		lamvec = [lamvec; z'*y];
		z = y/norm(y);
	end
end
