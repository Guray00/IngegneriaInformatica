function [xvec, valvec] = newton(f, df, x0, tol, maxit)
	xvec = x0;
	valvec = f(x0);
	for j = 1:maxit
		xnew = xvec(end) - valvec(end)/df(xvec(end));
		xvec = [xvec; xnew];
		valvec = [valvec; f(xnew)];
		if abs(valvec(end)) < tol
			break
		end	
	end
end

