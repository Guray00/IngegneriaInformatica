function x=inf_solve(L,b)
s=size(L);
n=s(1);
x=zeros(n,1);
	for i=1:n
		p=b(i); % accumulatore
		for j=1:i-1
		p=p-L(i,j)*x(j);
		end
		x(i)=p/L(i,i);
	end
end
