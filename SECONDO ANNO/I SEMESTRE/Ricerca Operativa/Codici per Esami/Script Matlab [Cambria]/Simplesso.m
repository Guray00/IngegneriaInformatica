function [x, v, baseO] = Simplesso(c, A, b, base, ciclo)
% Dato un problema di minimo con poliedro Ax<=b stampa tutti i passaggi necessari a trovare la soluzione ottima
% - c : vettore riga di n elementi
% - A : matrice m x n
% - b : vettore colonna di m elementi
c = -c;
[m, n] = size(A);
base = sort(base);
j = 1;
while(ciclo ~= 0)
    disp("************");
    fprintf("* Passo %d: *\n", j);
    disp("************");
    j = j+1;
    
    disp("Base attuale: ");
    disp(base);
    
    Ab = zeros(n);
    for i = 1:length(base)
        Ab(i, :) = A(base(i), :);
        bb(i, 1) = b(base(i));
    end
    
    x_sgn = inv(Ab)*bb;
    ver = round(A * x_sgn - b, 4);
    
    disp("Matrice di Base: ");
    disp(Ab);
    disp("Sol. attuale: ");
    disp(x_sgn);

    deg = find(ver == 0);
    if(length(deg) > length(base))
        fprintf("Base Degenere\n\n");
    end
    
    if(all(ver <= 0))
        y = inv(transpose(Ab))*transpose(c);
        disp("Soluzione duale attuale ( y = inv(Ab')*c'): ");
        disp(y);
        
        h = find(y < 0);
        if(isempty(h))
            disp("------------------------");
            disp("Soluzione Ottima trovata");
            x = x_sgn;
            v = c * x_sgn;
            baseO = base;
            return
        else
            h = h(1);
            disp("Vincolo uscente h: ")
            disp(base(h));
            W = -inv(Ab);
            disp("Matrice W = -inv(Ab)");
            disp(W);
            W = W(1:n, h);
            min = [-1, 0];
            for i = 1:m
                if(~ismember(base, i))
                    tmp = A(i, 1:n)*W;
                    fprintf("- A%d * W%d= ", i, base(h));
                    disp(tmp);
                    if(tmp > 0)
                        r_tmp = (b(i) - A(i, 1:n) * x_sgn)/tmp;
                        fprintf("\t\t r%d = (b%d - A%d*x)/%f", i, i, i, tmp);
                        disp(r_tmp);
                        if(min(1) == -1 || min(2) > r_tmp)
                            min = [i, r_tmp];
                        end
                    end
                end
            end
            if(min(1) == -1)
                fprintf("P = +infinito");
                ciclo = 0;
            else
                fprintf("Indice k entrante = %d \n", min(1));
                base(h) = min(1);
                base = sort(base);
                disp("------------------");
                ciclo = ciclo - 1;
            end
        end
    else
        ciclo = 0;
        disp("Base non ammissibile");
    end
end
end