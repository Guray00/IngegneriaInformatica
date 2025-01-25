function C = spline_nat_equi(x, f)
% funzione che calcola la matrice dei coefficienti della spline; si usa la funzione conv per calcolare il prodotto di polinomi
	h = x(2)-x(1);
	k = length(x) - 1;
	mat = 4*eye(k+1)+diag(ones(k,1), 1)+diag(ones(k,1), -1); 
	mat(1,1) = 2; 
	mat(end,end) = 2;
	y = zeros(k+1, 1);
	y(1) = f(2)-f(1);
	y(end)=f(end)-f(end-1);
	y(2:end-1)=f(3:end)-f(1:end-2);
	y = 3*y/h;
	m = mat\y; 
	C = zeros(k, 4);
	for j = 1:k
		p1 = (m(j) + 2*f(j)/h) * [1 -x(j)];
		p1(2) = p1(2)+f(j);
		p2 = [1 -x(j+1)]/h;
		p2 = conv(p2, p2);
		p3 = (m(j+1) - 2*f(j+1)/h) * [1 -x(j+1)];
		p3(2) = p3(2)+f(j+1);
		p4 = [1 -x(j)]/h;
		p4 = conv(p4, p4);	
		C(j, :) = conv(p1, p2) + conv(p3, p4);
	end
end
