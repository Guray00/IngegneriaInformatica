n = [1:150];
tempi= zeros(n(end),3);
for j = 1:n(end)
	A = randn(j);
	tempi(j, 1) = timeit(@() det(A));
	tempi(j, 2) = timeit(@() mydet2(A));
	if j <= 10
		tempi(j, 3) = timeit(@() mydet(A));
	end	
end
loglog(n, n.^3, 'k')
hold on
loglog(n, tempi(:, 1), 'y', n, tempi(:, 2), 'r', n, tempi(:, 3), 'b')
legend('n^3', 'det', 'mydet2', 'mydet')
