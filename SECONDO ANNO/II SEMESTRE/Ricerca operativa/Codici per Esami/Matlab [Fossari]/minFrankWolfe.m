function new_xk = minFrankWolfe(x, f, A, b, xk)
% Dato il vettore di variabili x, svolge Frank-Wolfe sui minimi per f su D descritto da A e b, partendo dal punto xk.

    % min f
    % Ax <= b

    arguments
        x (2, 1) % Assuming x is a 2x1 vector
        f (1, 1)
        A (:, :)
        b (:, 1)
        xk (2, 1)
    end

    fprintf("FW per minimi. \n")

    grad_f = simplify(jacobian(f, x).'); % Use jacobian for symbolic gradient
    grad_f_xk = subs(grad_f, x, xk);
    grad_f_xk

    % Convert symbolic expressions to numeric values
    grad_f_xk_numeric = double(grad_f_xk);

    linearized_objective = -grad_f_xk_numeric.' * x;
    linearized_objective

    % Solve the linear programming problem
    yk = linprog(grad_f_xk_numeric, A, b, [], [], [], []);
    yk

    syms t
    direction_f = simplify(subs(f, x, xk + t * (yk - xk)));
    direction_f
    handlef = matlabFunction(direction_f);

    candidate_t = fminbnd(handlef, 0, 1);
    candidates = [0 candidate_t 1];
    [~, min_idx] = min(arrayfun(handlef, candidates));
    tk = candidates(min_idx);
    tk

    dk = yk - xk;
    dk
    new_xk = xk + tk * dk;
end
