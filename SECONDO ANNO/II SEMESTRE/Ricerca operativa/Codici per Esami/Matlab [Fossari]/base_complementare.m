function non_base = base_complementare(base,len)
% data una certa lunghezza ed una base, la funzione ne trova gli indici
% complementari, ovvero quelli rimasti
j = 1;
for i = 1:len
    if ~ismember(i, base)
        non_base(j) = i;
        j = j + 1;
    end
end
end

