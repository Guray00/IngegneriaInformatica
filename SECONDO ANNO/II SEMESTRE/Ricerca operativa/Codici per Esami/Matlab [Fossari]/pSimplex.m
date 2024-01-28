function [x, y] = pSimplex(c, A, b, baseIndex, opt)

    % Example
    % c = [-7 1];
    % b = [4 -6 5 22 6 16];
    % A = [
    %     -3 2
    %     -1 -3
    %     0 1
    %     3 2
    %     1 0
    %     2 -1
    %     ];
    % i = [2, 5];
    % x = primalSimplex(c, A, b, i);

    arguments
        c (:, 1)
        A (:, :)
        b (:, 1)
        baseIndex (:, 1)
        opt.depthLimit = 2
        opt.currentDepth = 1
    end

    fprintf("\nPrimal Simplex step %d \n", opt.currentDepth)

    [x, y] = baseSolutionProblem(c, A, b, baseIndex, noPrint = true);

    primal_constraints = b - A * x;
    primal_constraints = roundFloating(primal_constraints);

    if any(primal_constraints < 0)
        fprintf("x not admissible\n")
        return
    end

    if all(y >= 0)
        disp("optimum found")
        return
    end

    % ----------------- get exiting index h and entering index k ----------------- %

    h = find(y < 0, 1); % 1st index, Bland rule

    W = zeros(size(A))';
    W(:, baseIndex) =- (A(baseIndex, :) ^ -1);

    direction_vector = A * W(:, h);

    % direction_vector = 0 | -1 for base indices
    if all(direction_vector <= 0)
        fprintf("optimun value is Infinity \n")
        return
    end

    all_ratios = primal_constraints ./ direction_vector;

    % no need to filter not_base_indices N,
    % as direction_vector > 0 is already subset of N
    ratios = all_ratios(direction_vector > 0);

    k = find(all_ratios == min(ratios), 1); % 1st index, Bland rule

    newBase = baseIndex;
    newBase(newBase == h) = k;
    newBase = sort(newBase);

    infoData = [
        "base" toRationalString(baseIndex)
        "x" toRationalString(x)
        "y" toRationalString(y)
        "f function value " dot(c, x)
        "h exiting index " h
        "k entering index " k
        "r ratios " toRationalString(ratios)
        "new base " toRationalString(newBase)
        ];
    fprintf("\n %s \n", toTableString(infoData))

    fprintf("DEBUG: b - AX = [ %s ] \n", toRationalString(primal_constraints))
    fprintf("DEBUG: A*Wh = [ %s ] \n", toRationalString(direction_vector))
    fprintf("DEBUG: all ratios = [ %s ] \n", toRationalString(all_ratios))
    fprintf("DEBUG: W matrix:\n");
    W

    if (opt.currentDepth >= opt.depthLimit)
        fprintf("Max depth reached: %d, stop simplex \n", opt.depthLimit)
        return
    end

    x = pSimplex(c, A, b, newBase, currentDepth = opt.currentDepth + 1, depthLimit = opt.depthLimit);
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
        colNames (1, :) = ["key", "value"]
    end

    if size(matrix, 2) == length(colNames)
        table = array2table(matrix, "VariableNames", colNames);
    else
        table = array2table(matrix);
    end

    str = formattedDisplayText(table, "SuppressMarkup", true, "LineSpacing", "compact");
    str = regexprep(str, '"', ' '); % remove " char

end