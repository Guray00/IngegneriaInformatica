function [x_out, A_out, b_out] = PianiDiTaglioGomory(c, A, b, lb, ub, max, number)
% Fornisce i primi /*number*/ piani di taglio (max = 1 : problema di massimo)
% PianiDiTaglioGomory(c, A, b, lb, ub, max, number)
% Il formato di input del problema è Ax <= b
% INPUT:
%   c: vettore riga intero di n elementi
%   A: matrice intera di m x n elementi
%   b: vettore colonna intero di m elementi
%   lb: lowerbound
%   ub: upperbound
%   max: bool, 1 indica problema di massimo, 0 di minimo
%   number: numero di piani di taglio desiderati al massimo

if(number <= 0)
    disp("Entra un numero sensato bro");
else
    [vI, vS, x] = getValutazioni(c, A, b, lb, ub, max);
    fprintf("v pre taglio: [%d, %d] \n", vI, vS);
    if(vI == vS)
        disp("Soluzione Intera!");
    else
        if(~isempty(ub))
            A = [A; diag(ones(length(ub), 1))];
            b = [b; ub];
        end
        delta = ones(size(A, 1), 1);
        c_rc = [c, zeros(1, size(A, 1))];
        x_rc = [x; zeros(size(A, 1), 1)];
        A_rc = [A, diag(delta)];
                
        
        diff = [zeros(length(x), 1); b - A_rc * x_rc];
        x_rc = round(x_rc + diff, 6);
        base = find(x_rc ~= 0);
        non_base = find(x_rc == 0);
        
        while(length(base) ~= size(A_rc, 1)) 
            base = sort([base; non_base(1)]);
            non_base(1) = [];
        end

        disp("Matrice estesa: ");
        disp(A_rc);
        disp("x_rc: ");
        disp(x_rc');
        disp("B = ");
        disp(base');
        disp("N = ");
        disp(non_base');
        
        A_out = A_rc;
        b_out = b;

        Ab = A_rc(1:size(A_rc, 1), base);
        An = A_rc(1:size(A_rc, 1), non_base);
        
        disp("Ab = ");
        disp(Ab);
        disp("An = ");
        disp(An);
        
        At = round(inv(Ab) * An, 10);
    
        disp("A_tilde = ");
        disp(At);
        r_arr = find(x_rc ~= floor(x_rc));
    
        if(isempty(r_arr))
            disp("x_RC  a componenti intere!");
        else
            number = min([number, length(r_arr)]);
            for k = 1 : number
                r = r_arr(k);
                j = base == r;
                fprintf("Piano di taglio per la componente %d \n \t", r);
                for i = 1:length(non_base)
                    fprintf("{%f} x%d ", At(j, i), non_base(i));
                    if(i ~= length(non_base))
                        fprintf("+ ");
                    end
                end
                fprintf("≥ ");
                fprintf("{%f} \n \t", x_rc(r));

                tt = zeros(1, size(A_out, 2));
                for i = 1:length(non_base)
                    tmp = parteFraz(At(j, i));
                    tt(non_base(i)) = -tmp;
                    [num, den] = rat(tmp);
                    fprintf("%d/%d x%d ", num, den, non_base(i));
                    if(i ~= length(non_base))
                        fprintf("+ ");
                    end
                end
                fprintf("≥ ");
                tmp = parteFraz(x_rc(r));
                b_out = [b_out; -tmp];
                A_out = [A_out; tt];
                [num, den] = rat(tmp);
                fprintf("%d/%d \n\n", num, den);
            end
        end
    end
end

[vI, vS, x_out] = getValutazioni(c_rc, A_out, b_out, zeros(length(c_rc), 1), [], max);
if(x_out(1: length(c)) == floor(x_out(1: length(c))))
    disp("Arrivato all'ottimo!");
else
    fprintf("v post taglio: [%d, %d] \n", vI, vS);
end
end
    
function [vI, vS, x] = getValutazioni(c, A, b, lb, ub, max)
if(max)
    [x, v] = linprog(-c, A, b, [], [], lb, ub);
    v = -v;
    vI = c * floor(x);
    vS = floor(v);   
else
    [x, v] = linprog(c, A, b, [], [], lb, ub);
    vI = ceil(v);
    vS = c * ceil(x);
end
end

function x = parteFraz(y)
    x = y - floor(y);
end