i = 1;
for n =2:20
	x = linspace(-2, 2, n);
	V = vander(x);
	V=V(:, end:-1:1);
	condiz(i)=cond(V);
	i=i+1;
end
punti = [2:n];
loglog(punti, condiz,'-m*')
hold on
loglog(punti, punti, 'r', punti, punti.^2, 'b', punti, punti.^6,'c', punti, exp(punti),'k')
legend('cond(V)', 'n', 'n^2','n^6','exp(x)')
