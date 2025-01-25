function a = myexp2(x,n)
	% calcola e^x con Taylor troncato
	% ma usa solo O(n) operazioni ed evita overflow
	t = 1; % accumulatore che contiene il termine generico della sommatoria
	a = 1; % accumulatore che contiene le somme parziali
	for k = 1:n
		t = t * x / k;
		a = a + t;
	end
end
