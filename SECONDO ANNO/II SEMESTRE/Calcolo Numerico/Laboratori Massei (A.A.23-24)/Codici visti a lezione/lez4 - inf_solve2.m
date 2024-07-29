function x=inf_solve(L,b)
s=size(L);
n=s(1);
x=zeros(n,1);
	for i=1:n
		p=b(i); % accumulatore
		p = p-L(i, 1:i-1)*x(1:i-1);
		x(i)=p/L(i,i);
	end
end
