function C = linear_interp(x, f)
% funzione che calcola la matrice rappresentante l'interpolante lineare a tratti di f negli intervalli definiti dai nodi in x
	x = x(:); f = f(:); % si assicura che x e f siano vettori colonna
	p = length(x) - 1;
	C = zeros(p, 2);
	C(:, 1) = (f(2:end)-f(1:end-1))./(x(2:end)-x(1:end-1));
	C(:, 2) = -C(:, 1) .* x(1:end-1) + f(1:end-1);
end
