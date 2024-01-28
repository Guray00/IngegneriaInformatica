function cuts = gomory(c, A, b)
    %
    % Gomory cutting plane
    % c, A, b in dual form
    %   min c*x
    %   A*x = b
    %   x >= 0
    %
    % Example
    % c = [-5 -14];
    % A = [
    %     18 8 1 0
    %     14 18 0 1
    %     ];
    % b = [55 61];
    % cuts = gomory(c, A, b);

    arguments
        c (:, 1)
        A (:, :)
        b (:, 1)
    end

    % need e variables in objective for linprog    
    if length(c) < width(A)
        c(end + 1:width(A)) = 0;
    end

    assert(length(c) == width(A), "length(c) != width(A)")
    assert(length(b) == height(A), "length(b) != height(A)")

    % ---------------------------------------------------------------------------- %
    %                             Find relaxed optimum                             %
    % ---------------------------------------------------------------------------- %

    ub = c * 0;
    x_relaxed = linprog(c, [], [], A, b, ub, []);
    x_relaxed

    % ---------------------------------------------------------------------------- %
    %                          Calculate fractional coeff                          %
    % ---------------------------------------------------------------------------- %

    fractional = @(x) sym(x) - floor(sym(x));
    baseIndex = logical(fractional(x_relaxed) ~= 0);

    fractional_base_indices = sum(baseIndex == 1);

    if fractional_base_indices == 0
        fprintf("Already integer solution \n")
        return
    elseif fractional_base_indices < size(A, 1)
        fprintf("Degenerate solution, using first index available \n")
        num_elem = size(A, 1) - fractional_base_indices;
        baseIndex(x_relaxed > 1e-6) = 1;
        %{
        i = 1;
        while num_elem
            if(baseIndex(i) == 0 && x_relaxed(i)) 
                baseIndex(i) = 1;
                num_elem = num_elem - 1;
            end
            i = i + 1;
        end
%}
    end
        

    Ab = A(:, baseIndex)
    An = A(:, ~baseIndex)
    At = inv(Ab)*An;
    At

    fractional_At = fractional(At);
    fractional_At(fractional_At < 1e-6) = 0;
    fractional_At
    fractional_xbase = fractional(x_relaxed(baseIndex))

    % ---------------------------------------------------------------------------- %
    %                             Calculate Gomory cuts                            %
    % ---------------------------------------------------------------------------- %

    syms("x", [size(A, 2) - size(A, 1) 1])
    syms("e", [size(A, 1) 1])

    coeff = [x; e];

    cuts = (fractional_At * coeff(~baseIndex)) - fractional_xbase >= 0;

    fprintf("\nGomory cuts, raws with slack variables e: \n\n%s \n", formattedDisplayText(cuts))

    % ---------------------------------------------------------------------------- %
    %                          substitute slack variables                          %
    % ---------------------------------------------------------------------------- %

    equations = A * coeff == b;

    for i = 1:length(e)
        equations(i) = isolate(equations(i), e(i));
    end

    cuts = subs(cuts, lhs(equations), rhs(equations));
    cuts = simplify(cuts * -1);

    r = find(baseIndex);
    fprintf("\nGomory cuts, simplified: \n\n%s \n", formattedDisplayText(table(r, cuts), "SuppressMarkup", true))

    end