function [y, x] = dSimplex(c, A, b, baseIndex, opt)
    % using same c A b notation of primal form
    %
    % accept both matrix A primal or dual form
    % if size A = n x m and n < m, it will transpose A
    % TODO remove this, add size check
    %
    %   min y*b
    %   y*A = c

    % c = [2 1];
    % b = [3 -7 5 22 14 15];
    % A = [
    %     -1 -1 0 3 2 2
    %     1 -4 1 2 1 -2
    %     ];
    % x = dualSimplex(c, A, b, [4 6]);

    arguments
        c (:, 1)
        A (:, :)
        b (:, 1)
        baseIndex (:, 1)
        opt.depthLimit = 2
        opt.currentDepth = 1
    end

    if size(A, 1) < size(A, 2)
        A = A';
    end

    fprintf("\nDual Simplex step %d \n", opt.currentDepth)

    [x, y] = baseSolutionProblem(c, A, b, baseIndex, noPrint = true);

    if any(y < 0)
        fprintf("y not admissible\n")
        return
    end

    primal_constraints = b - A * x;
    primal_constraints = roundFloating(primal_constraints);

    if all(primal_constraints >= 0)
        disp("optimum found")
        return
    end

    % ----------------- get exiting index h and entering index k ----------------- %

    k = find(primal_constraints < 0, 1); % 1st index, Bland rule

    W = zeros(size(A))';
    W(:, baseIndex) =- (A(baseIndex, :) ^ -1);

    direction_vector = A(k, :) * W;

    if all(direction_vector(baseIndex) >= 0)
      fprintf("optimun value is -Infinity \n")
        return
    end

    all_ratios = y ./ -direction_vector';

    ratios = all_ratios(direction_vector < 0);

    h = find(all_ratios == min(ratios), 1); % 1st index, Bland rule

    newBase = baseIndex;
    newBase(newBase == h) = k;
    newBase = sort(newBase);

    infoData = [
        "base" toRationalString(baseIndex)
        "x" toRationalString(x)
        "y" toRationalString(y)
        "f function value " dot(b, y)
        "h exiting index " h
        "k entering index " k
        "r ratios " toRationalString(ratios)
        "new base " toRationalString(newBase)
        ];
    fprintf("\n %s \n", toTableString(infoData))

    fprintf("DEBUG: b - AX = [ %s ] \n", toRationalString(primal_constraints))
    fprintf("DEBUG: A*Wh = [ %s ] \n", toRationalString(direction_vector))
    fprintf("DEBUG: -y / (A*Wh) all ratios = [ %s ] \n", toRationalString(all_ratios))

    if (opt.currentDepth >= opt.depthLimit)
        fprintf("Max depth reached: %d, stop simplex \n", opt.depthLimit)
        return
    end

    x = dualSimplex(c, A, b, newBase, currentDepth = opt.currentDepth + 1, depthLimit = opt.depthLimit);
end

% utils function
function str = toRationalString(o)

    arguments
        o (1, :)
    end

    str = strtrim(rats(o));
    str = regexprep(str, ' +', ' ');
end

function str = toTableString(matrix, colNames)

    arguments
        matrix (:, :)
        colNames = ["key", "value"]
    end

    table = array2table(matrix, "VariableNames", colNames);

    str = formattedDisplayText(table, "SuppressMarkup", true, "LineSpacing", "compact");
    str = regexprep(str, '"', ' '); % remove " char

end