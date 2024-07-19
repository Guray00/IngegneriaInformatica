function y = trapezi_gen(f, a, b, L)
	x = linspace(a, b, L+1);
	y = 0;
	for j = 1:L+1
		if j>1 && j<L+1
			y = y + 2*f(x(j));
		else
			y = y + f(x(j));				
		end
	end
	y = (b-a)*y/(2*L);
end
