function w = valuta_lagrange(x, y, v)
	k = length(x);
	m = length(v);
	w = zeros(m, 1);
	% rendo i tre vettori dei vettori colonna
	x = x(:);
	y = y(:);
	v = v(:)
	for j = 1:k
	 	xx = x([1:j-1, j+1:end]); % faccio un vettore temporaneo con i nodi di interpolazione meno il j-esimo
	 	tmp = ones(m, 1); % accumulatore
	 	for h = 1:k-1
	 		tmp = tmp .* (v - xx(h)); 
	 	end
	 	tmp = tmp / prod(x(j) - xx);
	 	w = w + y(j) * tmp;
	end
end
