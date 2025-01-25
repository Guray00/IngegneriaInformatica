function y = simpson_gen(f, a, b, L)
	x = linspace(a, b, 2*L+1);
	y = 0;
	for j = 1:2*L+1
		if j==1 || j== 2*L+1
			y = y + f(x(j));
		elseif mod(j, 2) == 1
			y = y + 2*f(x(j));	
		else
			y = y + 4*f(x(j));				
		end
	end
	y = (b-a)*y/(6*L);
end
