f = @(t) t.^2.*cos(t).^3;
true_val = integral(f, 0, 3);
tol = 10.^[-1:-1:-7];
L_trap = zeros(length(tol), 1);
L_simp = zeros(length(tol), 1);
% Loop per i trapezi
L = 1;
it = 1;
while 1
	app = trapezi_gen(f, 0, 3, L);
	if abs(app-true_val) < tol(end)
		L_trap(end) = L;
		break
	else
		if abs(app-true_val) < tol(it)
			L_trap(it) = L;
			it = it+1;
		end
		L = L + 1;
	end	
end

% Loop per simpson
L = 1;
it = 1;
while 1
	app = simpson_gen(f, 0, 3, L);
	if abs(app-true_val) < tol(end)
		L_simp(end) = L;
		break
	else
		if abs(app-true_val) < tol(it)
			L_simp(it) = L;
			it = it+1;
		end
		L = L + 1;
	end	
end

loglog(tol, L_trap+1, 'r', tol, 2*L_simp+1, 'b')
legend('trapezi', 'simpson')
xlabel('errore assoluto')
ylabel('valutazioni della funzione')
title('Trapezi vs Simpson')
