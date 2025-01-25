function x = x = sys_solve(A,b)
[U, c] = my_gauss(A, b);
x = sup_solve(U, c);
end
