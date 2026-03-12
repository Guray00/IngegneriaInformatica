function [y, v, baseO] = SimplessoDuale(c, A, b, base, ciclo)
% Dato un problema in FORMATO DUALE STANDARD stampa tutti i passaggi necessari a trovare la soluzione ottima
% - b : vettore riga i n elementi
% - A : matrice m x n
% - c : vettore colonna di m elementi

m = size(A, 1);
base = sort(base);
j = 1;
while(ciclo ~= 0)
    disp("************");
    fprintf("* Passo %d: *\n", j);
    disp("************");
    j = j+1;
    
    disp("Base attuale: ");
    disp(base);
    
    Ab = zeros(m);
    for i = 1:length(base)
        Ab(1:m, i) = A(1:m, base(i));
        bb(i, 1) = b(base(i));
    end
    disp("Matrice di Base forma duale: ");
    disp(Ab);
    
    Ab = transpose(Ab);
    y_sgn = round(transpose(c) * inv(Ab), 4);
    y_sgn = transpose(y_sgn);

    disp("Sol. attuale: ");
    disp(y_sgn);
    ciclo = 0;

    if(any(y_sgn == 0))
        fprintf("Base Degenere \n \n ");
    end
     
    if(all(y_sgn >= 0))
        x = inv(Ab)*bb;
        disp("Soluzione primale attuale: ");
        disp(x);
    
        ver = round(transpose(A) * x - transpose(b), 4);
        
        k = find(ver > 0);
        if(isempty(k))
            disp("------------------------");
            disp("Soluzione Ottima trovata");
            y_out = zeros(length(b), 1);
            for i = 1 : length(base)
                y_out(base(i)) = y_sgn(i);
            end
            y = y_out;
            v = b * y_out;
            baseO = base;
            ciclo = 0;
        else
            k = k(1);
            disp("Vincolo entrante k: ")
            disp(k);
            W = -inv(Ab);
            disp("Matrice W");
            disp(W);
            min = [-1, 0];
            Ak = A(1:m, k);
            Ak = transpose(Ak);

            for i = 1:size(W, 1)
                tmp = Ak * W(1:size(W,1), i);
                fprintf("- A%d * W%d= ", k, i);
                disp(tmp);
                if(tmp < 0)
                    r_tmp = -(y_sgn(i))/tmp;
                    fprintf("\t\t r%d = ", i);
                    disp(r_tmp);
                    if(min(1) == -1 || min(2) > r_tmp)
                        min = [i, r_tmp];
                    end
                end
            end
            if(min(1) == -1)
                fprintf("D = +infinito");
                ciclo = 0;
            else
                fprintf("Indice h uscente = %d \n", min(1));
                base(min(1)) = k;
                base = sort(base);
                disp("------------------");
                ciclo = ciclo - 1;
            end
        end
    else
        ciclo = 0;
        disp("Base non ammissibile");
        y = 0;
        v = 0;
        baseO = 0;
    end
end
end