function [res] = FrankWolfeMin_nonMio(f,A,b,xk,iter)
    % Algoritmo di FrankWolfe per problemi di minimo
    % FrankWolfeMin_nonMio(f,A,b,xk,iter)
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
    % 	-1  0;
    % 	0 -1;
    % 	1  2;
    % 	-2 -1;
    % ]
    % b = [0;0;8;-2]
    % xk = [0;3]
    % iter = 1
    %
    % res = FrankWolfeMin_nonMio(f,A,b,xk,iter)
    
    if(isrow(xk))
        xk = xk';
    end

    syX = sym('x', size(xk));
    syms t;

    res = [];

    n_iter = 0; % Numero di iterazione
    while iter > 0

        tmp = [];

        iter = iter - 1;
        n_iter = n_iter + 1;
        
        grad = zeros(length(syX), 1);
        for i = 1 : length(syX)
            grad(i) = diff(f, syX(i));
        end
        grd = double(subs(grad,syX,xk));

        yk = linprog(transpose(grd),A,b,[],[],[],[],optimoptions('linprog','Display','none'));

        if transpose(grd)*(yk-xk) == 0
            fprintf("Il punto (%s, %s) è il punto stazionario ottenuto con Frank-Wolfe\n",rationalCast_nonMio(xk))
            break;
        end

        original_expr = subs(f, syX, xk + t * (yk - xk));
        simplified_expr = simplify(original_expr);
        tet = matlabFunction(simplified_expr);
        
        formatted_expr = string(simplified_expr);
        formatted_expr = strrep(formatted_expr, '.*', '.* ');
        formatted_expr = strrep(formatted_expr, '.^', '.^ ');
        
        % Display the formatted expression
        %fprintf('φ(t) = %s\n', formatted_expr);

        pmin = fminbnd(tet,0,1);
        vals = [tet(0), tet(pmin), tet(1)];
        ts = [0,pmin,1];

        [~, index] = min(vals);

        tk = ts(index);

        tb = table();
        tb.('xk') = categorical(sprintf("(%s, %s)", rationalCast_nonMio(xk)));
        tb.('Problema lineare (min)') = transpose(grd)*syX;
        tb.('yk') = categorical(sprintf("(%s, %s)", rationalCast_nonMio(yk)));
        tb.('Direzione') = categorical(sprintf("(%s, %s)", rationalCast_nonMio(yk-xk)));
        tb.('φ(t)') = categorical(formatted_expr);
        tb.('Passo') = categorical(rationalCast_nonMio(tk));

        tmp.xk = xk;
        tmp.prob = transpose(grd)*syX;
        tmp.yk = yk;
        tmp.d = yk-xk;
        tmp.tk = tk;

        xk = xk+tk*(yk-xk);

        tmp.xNext = xk;

        tb.('xk next') = categorical(sprintf("(%s, %s)", rationalCast_nonMio(xk)));

        disp(tb);

        res = [res;tmp];
    end
    return;
end