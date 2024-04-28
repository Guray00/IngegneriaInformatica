function hessianaInfo = hessiana(f)
% Data f, ne calcola l'hessiana e mette a video alcune informazioni utili.
    syms x1 x2

    % Calcola la hessiana della funzione
    H = hessian(f, [x1, x2]);

    % Calcola il gradiente della funzione
    grad = gradient(f, [x1, x2]);

    % Calcola i punti in cui il gradiente si annulla
    zero_grad_points = solve(grad == [0; 0], [x1; x2]);
    zero_grad_points_vec = double([zero_grad_points.x1, zero_grad_points.x2]);

    % Determina la definizione della hessiana
    eigenvalues = eig(H);
    if all(eigenvalues > 0)
        definizione = 'definita positiva.';
    elseif all(eigenvalues < 0)
        definizione = 'definita negativa.';
    elseif all(eigenvalues >= 0)
        definizione = 'semidefinita positiva.';
    elseif all(eigenvalues <= 0)
        definizione = 'semidefinita negativa.';
    else
        definizione = 'non definita o semidefinita.';
    end

    % Prepara la struttura con le informazioni
    fprintf("Hessiana:");
    H
    fprintf("Gradiente:");
    grad
    fprintf("Punti a gradiente nullo:");
    zero_grad_points_vec
    fprintf("Autovalori:");
    eigenvalues
    fprintf("L'hessiana è di tipo %s\n",definizione);
end
