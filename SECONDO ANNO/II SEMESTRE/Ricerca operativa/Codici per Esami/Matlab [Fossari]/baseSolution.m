% function x = base(A, b, baseIndex)
function x = baseSolution(A, b, baseIndex)
    % BASESOLUTION solve AX = b with base indices

    arguments
        A (:, :) {mustBeNumeric}
        b (:, 1) {mustBeNumeric}
        baseIndex (:, 1) {mustBeNumeric, dimensionsCheck(A, b, baseIndex)} = 1:length(b)
    end

    Abase = A(baseIndex, :);
    bbase = b(baseIndex);

    % x = linsolve(Abase, bbase);

    % x = sym(Abase) \ sym(bbase)
    x = Abase \ bbase;

    % floating point round-off error, trying to cover it up
    % x = roundFloating(x);

end

% Custom validation function
function dimensionsCheck(A, b, indices)

    [n, m] = size(A);

    if (n ~= length(b))
        eid = 'Size:notEqual';
        msg = 'Size of b must equal of size1 matrix A: %d, got %d.';
        msg = sprintf(msg, n, length(b));
        throwAsCaller(MException(eid, msg))

    elseif (m ~= length(indices))
        eid = 'Size:notEqual';
        msg = 'Size of indices must equal of size2 matrix A: %d, got %d.';
        msg = sprintf(msg, m, length(indices));
        throwAsCaller(MException(eid, msg))
    end

end