% points = [
%     2 0
%     5 3
%     1 5
%     -1 1
%     ];

function [A, b] = polygonContraints (points)

    arguments
        points (:, 2)
    end

    middle = mean(points);
    middle = middle(:);

    order = convhull(points);
    vertices = points(order, :);

    syms x y

    eqs = [];
    % equalities = [];

    for i = 1:length(vertices) - 1
        p1 = vertices(i, :);
        p2 = vertices(i + 1, :);

        if p1(1) == p2(1)

            if middle(1) < p1(1)
                eqs = [eqs; x <= p1(1)];
                % equalities = [equalities; x - p1(1) == 0];
            else
                eqs = [eqs; x >= p1(1)];
                % equalities = [equalities; -x + p1(1) == 0];
            end

            continue
        end

        if p1(2) == p2(2)

            if middle(2) < p1(2)
                eqs = [eqs; y <= p1(2)];
                % equalities = [equalities; y - p1(2) == 0];
            else
                eqs = [eqs; y >= p1(2)];
                % equalities = [equalities; -y + p1(2) == 0];
            end

            continue
        end

        coeff = [p1(1) 1; p2(1) 1] \ [p1(2); p2(2)];

        a = coeff(1);
        b = coeff(2);
        mid_x = middle(1);
        mid_y = middle(2);

        % -ax + y <= b

        if -a * mid_x + mid_y <= b
            [~, den] = numden(- a * x + y -b);
            assert(den > 0)
            eq =- a * x + y -b <= 0;
            eq = eq * den;
            % equalities = [equalities; (- a * x + y - b) * den == 0];
        else
            [~, den] = numden(a * x - y +b);
            assert(den > 0)
            eq = a * x - y +b <= 0;
            eq = eq * den;
            % equalities = [equalities; (a * x - y + b) * den == 0];
        end

        eqs = [eqs; simplify(eq)];
    end

    eqs

    eqToMatrix = arrayfun(@(eq) lhs(eq) == rhs(eq), eqs);
    [A, b] = equationsToMatrix(eqToMatrix, [x y])

    A = double(A);
    b = double(b);

end