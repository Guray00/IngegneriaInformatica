function a = myexp(x,n)
	% calcola exp(x) con la serie di Taylor troncata all’n-esimo termine
	a = 1; %accumulatore
	for k = 1:n
		a = a + x^k/factorial(k);
	end
end
