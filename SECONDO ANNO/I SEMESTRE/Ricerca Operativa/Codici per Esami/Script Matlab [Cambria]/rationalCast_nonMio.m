function ret = rationalCast_nonMio(val)
    ret = strings(length(val(:,1)),length(val(1,:)));
    [n, d]=rat(val);
    for i=1:size(val,1)
        for j=1:size(val,2)
            if d(i,j)==1
                ret(i,j)=sprintf('%d',n(i,j));
            else
                ret(i,j)=sprintf('%d/%d',n(i,j), d(i,j));
            end
        end
    end
    return
end