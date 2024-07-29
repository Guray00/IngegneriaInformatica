function [x, res] = mq_normali(A, b)
	AA = A'*A;
	Ab = A'*b;
	x = AA\Ab;
	res = norm(b-A*x);
end
