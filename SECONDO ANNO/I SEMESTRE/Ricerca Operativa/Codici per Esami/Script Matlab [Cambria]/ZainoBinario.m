function ZainoBinario(v, p, P)
% Valutazioni inferiori e superiori dello Zaino Binario
%   v: vettore dei costi
%   p: vettore dei pesi
%   P: capacità totale dello zaino
%   r: vettore dei rapporti
if(length(v) ~= length(p))
    disp("Numeri sensati bro");
else
    r = v ./ p;
    [~, i_sort] = sort(r, 'descend');
    fprintf("r: "); disp(r);
    fprintf("r:\t\t");
    for i = 1 : length(r)
        [N, D] = rat(r(i));
        if(N == D) 
            fprintf("%d", r(i));
        else
            fprintf("%d/%d", N, D);
        end
        fprintf("\t");
    end
    fprintf("\n\n");

    [xI, vI] = valInferiore(v, i_sort, p, P, 1);
    [xS, vS] = valSuperiore(v, xI, i_sort, p, P, 1);

    fprintf("\n v in: [%d, %d]\n\n", vI, vS);
    
    [v_o, x_o] = BranchAndBound(v, i_sort, p, P, xS, vI);
    
    disp("=================");
    disp("Soluzione Ottima:");
    fprintf("x = "); disp(x_o);
    fprintf("v = "); disp(v_o);
end
end

function [xS, vS] = valSuperiore(v, x_start, i_sort, p, P, print)
    if(print)
        disp("Valutazione Superiore: ");
    end
    x = x_start;
    id = find(x ~= 0);
    for i = id
        P = P - p(i);
    end
    for i = i_sort
        if(x(i) ~= 0)
            continue;
        end
        if(p(i) <= P)
            x(i) = 1;
            P = P - p(i);
            if(print)
                fprintf("Passo %d: \n",  find(i_sort == i, 1));
                disp("xS:")
                disp(x);
                disp("Capacità rimanente: ");
                disp(P);
            end
        else
            x(i) = P / p(i);
            P = 0;
            break;
        end
    end
    
    vS = floor(dot(v, x));
    xS = x;
    
    fprintf("xS:\t");
    for i = 1 : length(xS)
        if(x(i) - floor(x(i)) == 0)
            fprintf("%d", x(i));
        else
            [N, D] = rat(x(i));
            fprintf("%d/%d", N, D);
        end
        fprintf("\t");
    end
    fprintf("\nCapacità rimanente: ");
    disp(P);
    fprintf("Valutazione superiore vS: ");
    disp(vS);
end

function [xI, vI] = valInferiore(v, i_sort, p, P, print)
    if(print)    
        disp("Valutazione Inferiore: ");
    end
    x = zeros(1, length(p));
    for i = i_sort
        if(p(i) <= P)
            x(i) = 1;
            P = P - p(i);
            if(print)
                fprintf("Passo %d: \n", find(i_sort == i, 1));
                disp("xI:")
                disp(x);
                disp("Capacità rimanente: ");
                disp(P);
            end
        end
        if(P == 0)
            break;
        end
    end
    xI = x;
    vI = dot(v, x);

    fprintf("xI: ");
    disp(xI);
    fprintf("Capacità rimanente: ");
    disp(P);
    fprintf("Valutazione inferiore vI: ");  
    disp(vI);
end


function [vI, x_ott] = BranchAndBound(v, i_sort, p, P, xS, vI, j, k, x_obb, x_ott)
    if(nargin == 6)
        j = 1;
        k = 1;
        x_obb = xS - xS;
        x_ott = [];
    end
    
    keep_0 = 0;
    keep_1 = 0;

    i = find(xS - floor(xS) ~= 0);
    
    fprintf("***********************************\n");
    fprintf("P%d%d \t | \tx%d = 0\n", j, k, i)
    
    i_sort0 = i_sort(i_sort - i ~= 0);
    xS(i) = 0;
    [x_0, vS_0] = valSuperiore(v, xS, i_sort0, p, P, 0);
    
    if(vS_0 <= vI)
        fprintf("TAGLIO IL BRANCH, vS(P%d%d) <= vI\n\n", j, k);
    elseif(all(x_0 - floor(x_0) == 0))
        vI = vS_0;
        x_ott = x_0;
        fprintf("******************\n");
        fprintf("* Aggiorno la vI *\t vI = %d\n", vI);
        fprintf("******************\n");
        fprintf("TAGLIO IL BRANCH, vS(P%d%d) == vI\n\n", j , k);
    else
        keep_0 = 1;
    end
    
    fprintf("***********************************\n");
    fprintf("P%d%d \t | \tx%d = 1\n", j, k + 1, i)
    
    x_obb1 = x_obb;
    x_obb1(i) = 1;
    if(p * x_obb1' > P)
        fprintf("TAGLIO IL BRANCH, x%d non ammissibile\n\n", i);
    else
        [x_1, vS_1] = valSuperiore(v, x_obb1, i_sort, p, P, 0);
        
        if(vS_1 <= vI)
            fprintf("TAGLIO IL BRANCH, vS(P%d%d) <= vS\n\n", j, k + 1);
        elseif(all(x_1 - floor(x_1) == 0))
            vI = vS_1;
            x_ott = x_1;
            fprintf("******************\n");
            fprintf("* Aggiorno la vI *\t vI = %d\n", vI);
            fprintf("******************\n");
            fprintf("TAGLIO IL BRANCH, vS(P%d%d) == vI\n\n", j , k + 1);
               
            if(vS_0 <= vI)
                fprintf("TAGLIO IL BRANCH, vS(P%d%d) <= vI\n\n", j, k);
            elseif(all(x_0 - floor(x_0) == 0))
                vI = vS_0;
                fprintf("******************\n");
                fprintf("* Aggiorno la vI *\t vI = %d\n", vI);
                fprintf("******************\n");
                fprintf("TAGLIO IL BRANCH, vS(P%d%d) == vI\n\n", j , k);
            else
                keep_0 = 1;
            end
        else
            keep_1 = 1;
        end
    end

    
    
    if(keep_0)
        [vI, x_ott] = BranchAndBound(v, i_sort0, p, P, x_0, vI, j+1, 2*k - 1, x_obb, x_ott);
    end
    if(keep_1)
        [vI, x_ott] = BranchAndBound(v, i_sort0, p, P, x_1, vI, j+1, 2*k + 1, x_obb1, x_ott);
    end
    
end