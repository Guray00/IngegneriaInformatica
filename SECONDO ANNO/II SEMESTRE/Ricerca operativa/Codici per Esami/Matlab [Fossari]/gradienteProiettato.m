function res = gradienteProiettato(f,A,b,xk,iter)
			% Algoritmo del gradiente proiettato
			% RicOp.gradienteProiettato(f,A,b,xk,iter)
			%
			% ⎰ min f(x)
			% ⎱ Ax<=b
			% 
			% xk: punto iniziale
			% iter: numero di iterazioni
			%
			% EXAMPLE:
			%
			% syms x1 x2
			% f = - 2*x1^2 - x2^2 + 4*x1 + 2*x2
			% A = [	
			%	-1  0; 
			%	0 -1; 
			%	1  2;
			%	-2 -1; 
			% ]
			% b = [0;0;8;-2]
			% xk = [0;3]
			% iter = 1
			%
			% res = RicOp.gradienteProiettato(f,A,b,xk,iter)

			syX = sym('x', size(xk));
			syms t;

			res = [];

			n_iter = 0; % Numero di iterazione
			while iter > 0

				tmp = [];

				iter = iter - 1;
				n_iter = n_iter + 1;

				grd = double(subs(gradient(f),syX,xk));

				M = A(A*xk==b,:);
				H = eye(length(M))-M'*(M*M')^-1*M;
				dk = -H*grd;

				tmp.M = M;
				tmp.H = H;
				tmp.dk = dk;

				if dk == 0
					break
				end

				mtk = linprog(-1,A*dk,b-A*xk,[],[],[],[],optimoptions('linprog','Display','none'));

				tmp.mtk = mtk;

				tet = matlabFunction(subs(f,syX,xk+t*dk));

				pmin = fminbnd(tet,0,mtk);
				vals = [tet(0), tet(pmin), tet(mtk)];
				ts = [0,pmin,mtk];

				[mi, index] = min(vals);

				tk = ts(index);

				tmp.tk = tk;

				xk = xk+tk*dk;

				tmp.xNext = xk;

                tb = table();
				tb.('M') = categorical(sprintf("(%s)",join(RicOp.rationalCast(M),',')));
                tb.('H') = categorical(sprintf("(%s)",join(RicOp.rationalCast(H),',')));
                tb.('Direzione') = categorical(sprintf("(%s, %s)", RicOp.rationalCast(dk)));
                tb.('Max spostamento') = categorical(RicOp.rationalCast(mtk));
                tb.('Passo') = categorical(RicOp.rationalCast(tk));
                tb.('xk next') = categorical(sprintf("(%s, %s)", RicOp.rationalCast(xk)));

                disp(tb);

				res = [res,tmp];

			end

end