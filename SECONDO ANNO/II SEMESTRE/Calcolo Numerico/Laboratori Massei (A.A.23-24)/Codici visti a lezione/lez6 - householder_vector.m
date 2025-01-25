function v = householder_vector(x)
	nrm = norm(x);
	if nrm == 0
		v = 0;
	else
		v = x;
		v(1) = v(1) + sign(x(1)) * nrm;
	end
end

