function y = piecewise_poly(x, C, z)
% Funzione che valuta una funzione polinomiale a tratti nei punti z
	n = length(z);
	p = length(x) - 1;
	y = zeros(n, 1);
	for j = 1:n
		ind = find(x<=z(j));
		ind = min(ind(end), p);
		y(j) = polyval(C(ind, :), z(j));
	end
end
