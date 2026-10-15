function [res] = GradienteProiettato_nonMio(f,A,b,xk,iter)
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
    % 
    % ⎰ max f(x)
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
    % 	-1  0;
    % 	0 -1;
    % 	1  2;
    % 	-2 -1;
    % ]
    % b = [0;0;8;-2]
    % xk = [0;3]
    % iter = 1
    % 
    % res = GradienteProiettato_nonMio(-f,A,b,xk,iter) 
    % (Notare il -f nella chiamata a funzione) !!

    if(isrow(xk))
        xk = xk';
    end
    syX = sym('x', size(xk));
    syms t;

    i_attivi = (find(A * xk - b == 0))';
    fprintf("Indici Attivi: "); disp(i_attivi);
    fprintf("\n");
    
    clear i_attivi;
    res = [];

    n_iter = 0; % Numero di iterazione
    while iter > 0

        tmp = [];

        iter = iter - 1;
        n_iter = n_iter + 1;
        
        grad = sym(zeros(length(syX), 1));
        for i = 1 : length(syX)
            grad(i) = diff(f, syX(i));
        end
        grd = double(subs(grad,syX,xk));

        M = A(A*xk==b,:);

        if(isempty(M))
            H = eye(length(grd));
        else
            H = eye(length(M))-M'*(M*M')^-1*M;
        end
        dk = -H*grd;

        tmp.M = M;
        tmp.H = H;
        tmp.dk = dk;

        if dk == 0
            break
        end
        
        % Con -1 come funzione obiettivo è come se fosse un
        % problema di max

        mtk = linprog(-1,A*dk,b-A*xk,[],[],[],[],optimoptions('linprog','Display','none'));

        tmp.mtk = mtk;

        tet = matlabFunction(subs(f,syX,xk+t*dk));

        formatted_expr = string(simplify(subs(f,syX,xk+t*dk)));
        formatted_expr = strrep(formatted_expr, '.*', '.* ');
        formatted_expr = strrep(formatted_expr, '.^', '.^ ');

        %disp(formatted_expr)

        pmin = fminbnd(tet,0,mtk);
        vals = [tet(0), tet(pmin), tet(mtk)];
        ts = [0,pmin,mtk];

        [~, index] = min(vals);

        tk = ts(index);

        tmp.tk = tk;

        xk = xk+tk*dk;

        tmp.xNext = xk;

        tb = table();
        if(~isempty(M))
            tb.('M') = categorical(sprintf("(%s)",join(rationalCast_nonMio(M),',')));
        else
            tb.('M') = categorical(sprintf("(%s)",join(rationalCast_nonMio(0),',')));
        end
        tb.('H') = categorical(sprintf("(%s)",join(rationalCast_nonMio(H),',')));
        tb.('Direzione') = categorical(sprintf("(%s, %s)", rationalCast_nonMio(dk)));
        tb.('Max spostamento') = categorical(rationalCast_nonMio(mtk));
        tb.('φ(t)') = categorical(formatted_expr);
        tb.('Passo') = categorical(rationalCast_nonMio(tk));
        tb.('xk next') = categorical(sprintf("(%s, %s)", rationalCast_nonMio(xk)));

        disp(tb);

        res = [res,tmp];

    end
end