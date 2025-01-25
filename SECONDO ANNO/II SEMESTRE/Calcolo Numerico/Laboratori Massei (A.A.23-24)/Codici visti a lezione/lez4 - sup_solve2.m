function x=sup_solve2(U,b)
s=size(U);
n=s(1);
x=zeros(n,1);
	for i=n:-1:1
		p=b(i); % accumulatore
		p = p - U(i, i+1:n) * x(i+1:n);
		x(i)=p/U(i,i);
	end
end
