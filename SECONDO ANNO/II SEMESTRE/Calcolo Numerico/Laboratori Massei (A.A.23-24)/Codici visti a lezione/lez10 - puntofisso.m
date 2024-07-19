function xvec = puntofisso(phi, x0, tol, maxit)
	xvec = x0;
	for j = 1:maxit
		xnew = phi(xvec(end));
		xvec = [xvec; xnew];
		if abs(xvec(end)-xvec(end-1)) < tol
			break
		end	
	end
end
