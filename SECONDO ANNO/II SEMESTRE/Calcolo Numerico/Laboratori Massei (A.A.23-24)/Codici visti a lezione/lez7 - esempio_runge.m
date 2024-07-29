function esempio_runge(k)
f = @(x) (100*x.^2-100*x + 26).^(-1);
s = linspace(0, 1, 1e3);
plot(s, f(s), 'b')
hold on
for j = 3:k
	d = linspace(0, 1, j);
	fd = f(d);
	px = plot(d, fd, 'mo', 'MarkerFaceColor', 'm', 'MarkerSize', 6);
	pip = plot(s, valuta_lagrange(d, fd, s), 'r');
	st = sprintf('Polinomio interpolante di grado %d', j);
	leg = legend('Funzione di Runge', st);
	axis([0, 1, -.5, 2.5])
	pause
	if j < k
		delete(px);
		delete(pip);
	end	
end

axis([0, 1, -.2, 2.5])

end
