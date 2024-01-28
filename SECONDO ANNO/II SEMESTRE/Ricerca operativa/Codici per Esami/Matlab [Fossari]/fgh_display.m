function [] = fgh_display(f, g, h, x, range, c)
% Disegna f entro il dominio descritto da g e h. Centra il grafo in "c" e lo calcola in un intorno "range" di c(15 massimo, 10 di default). Disegna poi degli altri punti "x" se inseriti.

% g1 = -x1^2 -x2^2 +1
% g2 = x1^2 -x2 -2
% f = -x1^2 -2*x2^2+8*x2
% ps = LKKT(x, f, [g1;g2], []).x
% fgh_display(f,[g1;g2],[],ps,[],[]) <-- disegna i valori della funzione entro D = {gi<=0, hj=0} ed i punti stazionari di LKKT.

% ATTENZIONE: la funzione potrebbe risultare difficile da computare quindi
%  poco veloce su pc non troppo performanti. Date in ogni caso un poco di
%  tempo a matlab di disegnare il tutto anche se a video è apparso "Fatto".

% NOTA: per domini di sole funzioni h pochissimi punti di f potrebbero
%  essere disegnati.

% BUG: Per qualche motivo le linee orizzontali sono disegnate come
%   verticali invertendo ascissa e ordinata, ma il calcolo del poliedro è
%   comunque corretto (bug solo grafico).

    syms x1 x2

    if isempty(range) || range > 15
        range = 10;
    end
    passo = range * 0.04;

    % Create a 2D scatter plot with color representing the function values
    figure;
    hold on

    if isempty(c)
        % Create a grid of points for visualization
        [x1_vals, x2_vals] = meshgrid(-range:passo:range, -range:passo:range);
    else
        [x1_vals, x2_vals] = meshgrid(c(1)-range:passo:c(1)+range, c(2)-range:passo:c(2)+range);
    end

    % Plot inequality constraints
    fimplicit(g, 'b', 'LineWidth', 1);
    fimplicit(h, 'r', 'LineWidth', 1);

    % Initialize satisfied_points as a logical matrix of true values
    disp('Calcolo dei punti soddisfatti da g e h.')
    satisfied_points = true(size(x1_vals));
% Evaluate the inequality constraints g(x1, x2) for each point in the grid
for i = 1 : length(g)
    satisfied_points = and(satisfied_points, double(subs(g(i), [x1, x2], {x1_vals, x2_vals})) <= 0);
end
for i = 1 : length(h)
    satisfied_points = and(satisfied_points, double(subs(h(i), [x1, x2], {x1_vals, x2_vals})) == 0);
end

    % Evaluate the function f(x1, x2) for each point in the grid
    %f_values = double(subs(f, [x1, x2], {x1_vals, x2_vals}));
    disp('Calcolo dei valori di f.')
    f_values = zeros(size(x1_vals));
    f_values(satisfied_points) = double(subs(f, [x1, x2], {x1_vals(satisfied_points), x2_vals(satisfied_points)}));

    % Create a mask for satisfied points
    satisfied_mask = logical(satisfied_points);

    % Apply the mask to keep only the values for satisfied points
    f_satisfied = f_values .* satisfied_mask;
    disp('Disegno di f.')
    scatter(x1_vals(satisfied_mask), x2_vals(satisfied_mask), 40, f_satisfied(satisfied_mask), 'filled');
    
    disp('Disegno dati finali.');
    % Plot additional points if provided
    if ~isempty(x)
        x = double(x);
        scatter(x(:,1), x(:,2), 100, 'x', 'MarkerEdgeColor', 'r');
    end
    
    % Plot the center point if provided
    if ~isempty(c)
        scatter(c(1), c(2), 40, 'r', 'o')
    end
    disp('Fatto.');
    xlabel('x1');
    ylabel('x2');
    title('Valori di f sul dominio di g e h.');
    colorbar; % Add a colorbar to indicate the function values
    % Fix the aspect ratio of the plot
    axis equal;
    hold off; % Release the hold on the plot
end