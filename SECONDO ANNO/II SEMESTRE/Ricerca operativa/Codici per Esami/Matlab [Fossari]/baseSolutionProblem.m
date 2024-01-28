function [x_sol, y_sol] = baseSolutionProblem(c, A, b, baseIndex, opt)
    % BASESOLUTION
    % given c, A, b in primal form notation
    % find with base indices:
    %       - primal base solution x
    %       - dual base solution y

    arguments
        c (:, 1) {mustBeNumeric}
        A (:, :) {mustBeNumeric}
        b (:, 1) {mustBeNumeric}
        baseIndex (:, 1) {mustBeNumeric} = 1:length(b)

        opt.noPrint logical = false

    end

    x_sol = baseSolution(A, b, baseIndex);

    A_dual = A(baseIndex, :)';
    b_dual = c;

    y_sol = zeros(length(b), 1);
    y_sol(baseIndex) = baseSolution(A_dual, b_dual);

    if ~opt.noPrint
        fprintf("x = [ %s ] \n", toRationalString(x_sol))
        fprintf("y = [ %s ] \n", toRationalString(y_sol))
    end

end

% utils function
function str = toRationalString(o)

    arguments
        o (1, :)
    end

    str = strtrim(rats(o));
    str = regexprep(str, ' +', ' ');
end