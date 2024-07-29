function [x, res] = mq_qr(A, b)
	[m, n] = size(A);
	[Q, R] = my_qr(A);
	c = Q'*b;
	x = R(1:n, 1:n) \ c(1:n);
	res = norm(c(n+1:end));
end
