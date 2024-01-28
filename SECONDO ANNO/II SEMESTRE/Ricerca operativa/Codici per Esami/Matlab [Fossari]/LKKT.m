function solution = LKKT(x, f, g, h)
% scrivere le disequazioni come gi = (...) e poi scrivere g = [g1;g2;...]


%

% syms x [2 1]
% f = x1 + x2;
% g = x1 ^ 2 + x2 ^ 2 - 2;
% h = x1 ^ 2 - x2;

% % ---

% syms x [2 1]
% f = x1 ^ 2 + 2 * x1 + x2 ^ 2 + 2 * x2;
% g = [
%     x1 + x2 ^ 2
%     x1 ^ 2 - 4
%     ];
% h = [];
% sol = LKKTsystem(x, f, g, h);



    % Example
    % syms x [2 1]
    % f = x1 ^ 2 + 2 * x1 + x2 ^ 2 + 2 * x2;
    % g = [
    %     x1 + x2 ^ 2
    %     x1 ^ 2 - 4
    %     ];
    % h = [x1 ^ 2 - x2];
    % sol = LKKTsystem(x, f, g, h);

    arguments
        x
        f (1, 1)
        g (:, 1) = []
        h (:, 1) = []
    end

    handler = @(f) sym(gradient(f, x));

    grad_f = gradient(f);
    grad_g = arrayfun(handler, g, "UniformOutput", false);
    grad_h = arrayfun(handler, h, "UniformOutput", false);

    % ---

    syms("lambda", [length(g) 1])
    syms("mu", [length(h) 1])

    grad_lagrangian = grad_f + ...
        sumMultiplierGradients(lambda, grad_g) + ...
        sumMultiplierGradients(mu, grad_h) == 0;

    system = [
        grad_lagrangian
        lambda .* g == 0
        h == 0
        g <= 0
        ];

    solution = solve(system, 'Real', true);

    table = struct2table(solution);

    table = mergevars(table, string(x), "NewVariableName", "x");
    table = mergevars(table, string(lambda), "NewVariableName", "lambda");
    table = mergevars(table, string(mu), "NewVariableName", "mu");

    symvars = symvar(f);
    x_values = table{:, "x"};

    for i = 1:height(x_values)
        table.f_value(i, 1) = subs(f, symvars, x_values(i, :));
    end

    solution.f_value = table.f_value;
    table = sortrows(table, "f_value");

    % open in live script to see latex formatted output
    t = struct2cell(solution);
    t = [t{:}];

    solution = table;
end

function sum = sumMultiplierGradients(multiplier, gradients)
    sum = 0;

    for i = 1:length(gradients)
        sum = sum + multiplier(i) * gradients{i};
        % multiplier(i)
        % gradients{i}
        % multiplier(i) .* gradients{i}
    end

end