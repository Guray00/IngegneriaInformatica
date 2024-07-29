function d = mydet(A)
	n = size(A, 1);
	if n == 1
		d = A;
	elseif n == 2
		d = A(1,1)*A(2,2)-A(1,2)*A(2,1);
	else	
		d = 0;
		for j=1:n
			d = d + (-1)^(j+1) * A(1, j) * mydet(A(2:n, [1:j-1, j+1:n]));
		end
	end	
end
