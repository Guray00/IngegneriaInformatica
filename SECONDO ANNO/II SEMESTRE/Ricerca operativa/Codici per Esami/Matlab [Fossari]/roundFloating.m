% floating point round-off error, trying to cover it up
function [x, isrounded] = roundFloating(x)

    rounded = round(x, 14);
    isrounded = false;

    % if ~isequal(rounded, x)
    if rounded ~= x
        isrounded = true;

        % warning("Rounded a number")

        xtxt = sprintf("%.15f \n", x);
        rtxt = sprintf("%.15f \n", rounded);
        % log.debug("\n------------- WARNING -------------\n")
        % log.debug("the given value [ \n %s ] \nwill be rounded to [ \n %s ] \n ", xtxt, rtxt)
        % log.debug("-----------------------------------\n")

    end

    x = rounded;

end