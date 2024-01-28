function result = frac(x)
    % parte frazionaria di un numero
    if(x < 0)
        f = floor(x);
        result = x - f;
        return;
    end
    result = x - floor(x);
end