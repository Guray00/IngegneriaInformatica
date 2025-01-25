
classdef RicOp
    % Classe matlab per ricerca operativa
    %   (aggiornata a febbraio 2024)
    %
    % 	Sistema LKKT: RicOp.LKKT(f,g,h)
    % 	Algoritmo di FrankWolfe per min: RicOp.FrankWolfeMin(f,A,b,xk,iter)
    %   Algoritmo di FrankWolfe per max: RicOp.FrankWolfeMax(f,A,b,xk,iter)
    % 	Algoritmo del gradiente proiettato: RicOp.gradienteProiettato(f,A,b,xk,iter)
    % 	Taglio di Gomory: RicOp.gomory(f,A,b)
    % 	K-albero di costo minimo: RicOp.kAlbero(M,n0,lim)
    % 	Algoritmo del nodo più vicino: RicOp.nodoPiuVicino(M,n0)
    % 	Algoritmo di dijkstra: RicOp.dijkstra(matrix,source)
    % 	Algoritmo di FordFulkerson: RicOp.FordFulkerson(matrix,source,destination)
    % 	Algoritmo del simplesso primale: RicOp.pSimplex(f,A,b,base,iter)
    % 	Algoritmo del simplesso duale: RicOp.dSimplex(f,A,b,base,iter)
    % 	Algoritmo del simplesso su reti di costo minimo capacitate: RicOp.flowSimplex(matrix,b,T,U,iter)
    %
    % NOTA:
    % Attenzione a quando usate queste funzioni, potrebbero non funzionare in casi particolari...

    methods(Static)
        % Funzioni di Ricerca Operativa

        function [A,b] = vert2con(V)
            % VERT2CON - convert a set of points to the set of inequality constraints
            %            which most tightly contain the points; i.e., create
            %            constraints to bound the convex hull of the given points
            %
            % [A,b] = vert2con(V)
            %
            % V = a set of points, each ROW of which is one point
            % A,b = a set of constraints such that A*x <= b defines
            %       the region of space enclosing the convex hull of
            %       the given points
            %
            % For n dimensions:
            % V = p x n matrix (p vertices, n dimensions)
            % A = m x n matrix (m constraints, n dimensions)
            % b = m x 1 vector (m constraints)
            %
            % NOTES: (1) In higher dimensions, duplicate constraints can
            %            appear. This program detects duplicates at up to 6
            %            digits of precision, then returns the unique constraints.
            %        (2) See companion function CON2VERT.
            %        (3) ver 1.0: initial version, June 2005.
            %        (4) ver 1.1: enhanced redundancy checks, July 2005
            %        (5) Written by Michael Kleder
            %
            % EXAMPLE:
            %
            % V=rand(20,2)*6-2;
            % [A,b]=vert2con(V)
            % figure('renderer','zbuffer')
            % hold on
            % plot(V(:,1),V(:,2),'r.')
            % [x,y]=ndgrid(-3:.01:5);
            % p=[x(:) y(:)]';
            % p=(A*p <= repmat(b,[1 length(p)]));
            % p = double(all(p));
            % p=reshape(p,size(x));
            % h=pcolor(x,y,p);
            % set(h,'edgecolor','none')
            % set(h,'zdata',get(h,'zdata')-1) % keep in back
            % axis equal
            % set(gca,'color','none')
            % title('A*x <= b  (1=True, 0=False)')
            % colorbar
            format short
            k = convhulln(V);
            c = mean(V(unique(k),:));
            V=V-repmat(c,[size(V,1) 1]);
            A  = NaN*zeros(size(k,1),size(V,2));
            rc=0;
            for ix = 1:size(k,1)
                F = V(k(ix,:),:);
                if rank(F,1e-5) == size(F,1)
                    rc=rc+1;
                    A(rc,:)=F\ones(size(F,1),1);
                end
            end
            A=A(1:rc,:);
            b=ones(size(A,1),1);
            b=b+A*c';
            % eliminate dumplicate constraints:
            [~,I]=unique(num2str([A b],6),'rows');
            A=A(I,:); % rounding is NOT done for actual returned results
            b=b(I);

            for i=1:size(A,1)

                [num, ~] = rat([A(i,:),b(i)]);
                num = max(num);

                A(i,:) = A(i,:) / num;
                b(i) = b(i) / num;

                [~, dem] = rat([A(i,:),b(i)]);

                mul = lcm(sym(dem));
                A(i,:) = A(i,:) * mul;
                b(i) = b(i) * mul;
            end
            disp('A')
            disp(A)
            disp('b')
            disp(b)
            A=round(A);
            b=round(b);
            return
        end

        function [] = LKKT(f,g,h)
            % Sistema LKKT
            % RicOp.LKKT(f,g,h)
            %
            % f: funzione obbiettivo
            % g: vincoli con <=
            % h: vincoli con =
            %
            % EXAMPLE:
            %
            % syms x1 x2
            % f = - x1^2 - 2*x2^2 + 8*x2
            % g = [
            % 	- x1^2 - x2^2 + 1;
            % 	x1^2 - x2 - 2;
            % ]
            %
            % res = RicOp.LKKT(f,g)

            

            if nargin == 0
                error("Inserire la funzione obbiettivo.");
            elseif nargin <= 2
                h=[];
                if nargin == 1
                    g=[];
                end
            end

            res.x=[];
            res.l=[];
            res.m=[];
            res.fo=[];
            type=[];

            syL = sym('l', size(g));
            syM = sym('m', size(h));
            syX = symvar([f;g;h]);
            % disp(syX)

            eqs = gradient(f);
            for i=1:size(g,1)
                gradgi=[diff(g(i), syX(1)); diff(g(i), syX(2))];
                eqs = eqs + syL(i)*gradgi;
            end
            for i=1:size(h,1)
                gradhi=[diff(h(i), syX(1)); diff(h(i), syX(2))];
                eqs = eqs + syM(i)*gradhi;
            end
            eqs = eqs == 0;

            for i=1:size(g,1)
                eqs = [eqs; syL(i)*g(i) == 0];
            end

            eqs = [eqs; g<=0;h==0];

            display(eqs);

            sol = solve(eqs,'Real', true);
            H = hessian(f);

            for i=1:length(syX)
                res.x = [res.x, sol.(string(syX(i)))];
            end

            coefficients = polynomialDegree(f,syX);

            for i=1:length(res.x)
                if(max(coefficients)>2)
                    H_calculated=double(subs(H, syX,[res.x(i,:)]));
                else
                    H_calculated=double(H);
                end
                
                % Convert the symbolic matrix to a numeric matrix for evaluation
                
                [~,eigenv] = eig(H_calculated);

                eigenv = nonzeros(eigenv);

                if all(eigenv > 0)
                    type=[type; "Minimo locale"];
                else
                    if all(eigenv < 0)
                        type=[type; "Massimo locale"];
                    else
                        type=[type; "Sella"];
                    end
                end
            end

            for i=1:length(syL)
                res.l = [res.l, sol.(string(syL(i)))];
            end
            for i=1:length(syM)
                res.m = [res.m, sol.(string(syM(i)))];
            end

            tab = struct2table(sol);
            tab = mergevars(tab,string(syL),'NewVariableName','λ');
            tab = mergevars(tab,string(syM),'NewVariableName','μ');
            tab = mergevars(tab,string(syX),'NewVariableName','x');
            tab = movevars(tab,'x','Before',1);
            
            fo = zeros(size(tab.x,1),1);
            for i=1:size(tab.x,1)
                fo(i) = subs(f,syX,tab.x(i,:));
            end
            res.fo = fo;
            minValue = min(res.fo);
            indexOfMin = res.fo == minValue;
            type(indexOfMin)="Minimo globale";

            maxValue = max(res.fo);
            indexOfMax = res.fo == maxValue;
            type(indexOfMax)="Massimo globale";

            tab.('F.O.') = fo;

            tab=[tab,array2table(type)];

            tab = renamevars(tab,"type", "Tipologia (solo punti interni)");

            disp(tab);

            sol=[res.x, res.fo];
          
            % % Define a range for x and y values
            % x_values = linspace(-5, 5, 100);
            % y_values = linspace(-5, 5, 100);
            % [x_mesh, y_mesh] = meshgrid(x_values, y_values);    
            % z_values = double(subs(f, syX, {x_mesh, y_mesh}));
            % 
            % hold on
            % 
            % axis equal;
            % 
            % xlim([-10 10]);
            % ylim([-10 10]);
            % %zlim([0 2]);    
            % 
            % surf(x_mesh, y_mesh, z_values);
            % 
            % fimplicit3(g, 'MeshDensity',50);
            % 
            % s=scatter3(sol(:,1),sol(:,2),sol(:,3),'filled','g');
            % s.SizeData = 100;
            % colorbar
            % %view(2)
            % hold off

            return;
        end

        function [] = FrankWolfeMin(f,A,b,xk,iter)
            % Algoritmo di FrankWolfe per problemi di minimo
            % RicOp.FrankWolfe(f,A,b,xk,iter)
            %
            % ⎰ min f(x)
            % ⎱ Ax<=b
            %
            % xk: punto iniziale
            % iter: numero di iterazioni
            %
            % EXAMPLE:
            %
            % syms x1 x2
            % f = - 2*x1^2 - x2^2 + 4*x1 + 2*x2
            % A = [
            %	-1  0;
            %	0 -1;
            %	1  2;
            %	-2 -1;
            % ]
            % b = [0;0;8;-2]
            % xk = [0;3]
            % iter = 1
            %
            % res = RicOp.FrankWolfe(f,A,b,xk,iter)

            syX = sym('x', size(xk));
            syms t;

            res = [];

            n_iter = 0; % Numero di iterazione
            while iter > 0

                tmp = [];

                iter = iter - 1;
                n_iter = n_iter + 1;

                grd = double(subs(gradient(f),syX,xk));

                yk = linprog(transpose(grd),A,b,[],[],[],[],optimoptions('linprog','Display','none'));

                if transpose(grd)*(yk-xk) == 0
                    fprintf("Il punto (%s, %s) è il punto stazionario ottenuto con Frank-Wolfe\n",RicOp.rationalCast(xk))
                    break;
                end

                original_expr = subs(f, syX, xk + t * (yk - xk));
                simplified_expr = simplify(original_expr);
                tet = matlabFunction(simplified_expr);
                
                formatted_expr = string(simplified_expr);
                formatted_expr = strrep(formatted_expr, '.*', '.* ');
                formatted_expr = strrep(formatted_expr, '.^', '.^ ');
                
                % Display the formatted expression
                %fprintf('φ(t) = %s\n', formatted_expr);

                pmin = fminbnd(tet,0,1);
                vals = [tet(0), tet(pmin), tet(1)];
                ts = [0,pmin,1];

                [~, index] = min(vals);

                tk = ts(index);

                tb = table();
                tb.('xk') = categorical(sprintf("(%s, %s)", RicOp.rationalCast(xk)));
                tb.('Problema lineare (min)') = transpose(grd)*syX;
                tb.('yk') = categorical(sprintf("(%s, %s)", RicOp.rationalCast(yk)));
                tb.('Direzione') = categorical(sprintf("(%s, %s)", RicOp.rationalCast(yk-xk)));
                tb.('φ(t)') = categorical(formatted_expr);
                tb.('Passo') = categorical(RicOp.rationalCast(tk));

                tmp.xk = xk;
                tmp.prob = transpose(grd)*syX;
                tmp.yk = yk;
                tmp.d = yk-xk;
                tmp.tk = tk;

                xk = xk+tk*(yk-xk);

                tmp.xNext = xk;

                tb.('xk next') = categorical(sprintf("(%s, %s)", RicOp.rationalCast(xk)));

                disp(tb);

                res = [res;tmp];
            end
            return;
        end

        function [] = FrankWolfeMax(f,A,b,xk,iter)
            % Algoritmo di FrankWolfe per problemi di massimo
            % RicOp.FrankWolfe(f,A,b,xk,iter)
            %
            % ⎰ max f(x)
            % ⎱ Ax<=b
            %
            % xk: punto iniziale
            % iter: numero di iterazioni
            %
            % EXAMPLE:
            %
            % syms x1 x2
            % f = - 2*x1^2 - x2^2 + 4*x1 + 2*x2
            % A = [
            %	-1  0;
            %	0 -1;
            %	1  2;
            %	-2 -1;
            % ]
            % b = [0;0;8;-2]
            % xk = [0;3]
            % iter = 1
            %
            % res = RicOp.FrankWolfe(f,A,b,xk,iter)

            syX = sym('x', size(xk));
            syms t;

            res = [];

            n_iter = 0; % Numero di iterazione
            while iter > 0

                tmp = [];

                iter = iter - 1;
                n_iter = n_iter + 1;

                grd = double(subs(gradient(f),syX,xk));

                yk = linprog(-transpose(grd),A,b,[],[],[],[],optimoptions('linprog','Display','none'));

                if transpose(grd)*(yk-xk) == 0
                    fprintf("Il punto (%s, %s) è il punto stazionario ottenuto con Frank-Wolfe\n",RicOp.rationalCast(xk))
                    break;
                end

                original_expr = subs(f, syX, xk + t * (yk - xk));
                simplified_expr = simplify(original_expr);
                tet = matlabFunction(-simplified_expr);
                
                formatted_expr = string(simplified_expr);
                formatted_expr = strrep(formatted_expr, '.', '. ');
                formatted_expr = strrep(formatted_expr, '.^', '.^ ');
                
                % Display the formatted expression
                % fprintf('φ(t) = %s\n', formatted_expr);

                pmin = fminbnd(tet,0,1);
                vals = [tet(0), tet(pmin), tet(1)];
                ts = [0,pmin,1];

                [~, index] = min(vals);

                tk = ts(index);

                tb = table();
                tb.('xk') = categorical(sprintf("(%s, %s)", RicOp.rationalCast(xk)));
                tb.('Problema lineare (max)') = transpose(grd)*syX;
                tb.('yk') = categorical(sprintf("(%s, %s)", RicOp.rationalCast(yk)));
                tb.('Direzione') = categorical(sprintf("(%s, %s)", RicOp.rationalCast(yk-xk)));
                tb.('φ(t)') = categorical(formatted_expr);
                tb.('Passo') = categorical(RicOp.rationalCast(tk));

                tmp.xk = xk;
                tmp.prob = transpose(grd)*syX;
                tmp.yk = yk;
                tmp.d = yk-xk;
                tmp.tk = tk;

                xk = xk+tk*(yk-xk);

                tmp.xNext = xk;

                tb.('xk next') = categorical(sprintf("(%s, %s)", RicOp.rationalCast(xk)));

                disp(tb);

                res = [res;tmp];
            end
            return;
        end

        function [] = gradienteProiettato(f,A,b,xk,iter)
            % Algoritmo del gradiente proiettato
            % RicOp.gradienteProiettato(f,A,b,xk,iter)
            %
            % ⎰ min f(x)
            % ⎱ Ax<=b
            %
            % xk: punto iniziale
            % iter: numero di iterazioni
            %
            % EXAMPLE:
            %
            % syms x1 x2
            % f = - 2*x1^2 - x2^2 + 4*x1 + 2*x2
            % A = [
            %	-1  0;
            %	0 -1;
            %	1  2;
            %	-2 -1;
            % ]
            % b = [0;0;8;-2]
            % xk = [0;3]
            % iter = 1
            % 
            % 
            % ⎰ max f(x)
            % ⎱ Ax<=b
            %
            % xk: punto iniziale
            % iter: numero di iterazioni
            %
            % EXAMPLE:
            %
            % syms x1 x2
            % f = - 2*x1^2 - x2^2 + 4*x1 + 2*x2
            % A = [
            %	-1  0;
            %	0 -1;
            %	1  2;
            %	-2 -1;
            % ]
            % b = [0;0;8;-2]
            % xk = [0;3]
            % iter = 1
            %
            % res = RicOp.gradienteProiettato(-f,A,b,xk,iter) 
            % (Notare il -f nella chiamata a funzione) !!

            syX = sym('x', size(xk));
            syms t;

            res = [];

            n_iter = 0; % Numero di iterazione
            while iter > 0

                tmp = [];

                iter = iter - 1;
                n_iter = n_iter + 1;

                grd = double(subs(gradient(f),syX,xk));

                M = A(A*xk==b,:);
                H = eye(length(M))-M'*(M*M')^-1*M;
                dk = -H*grd;

                tmp.M = M;
                tmp.H = H;
                tmp.dk = dk;

                if dk == 0
                    break
                end
                
                % Con -1 come funzione obiettivo è come se fosse un
                % problema di max

                mtk = linprog(-1,A*dk,b-A*xk,[],[],[],[],optimoptions('linprog','Display','none'));

                tmp.mtk = mtk;

                tet = matlabFunction(subs(f,syX,xk+t*dk));

                formatted_expr = string(simplify(subs(f,syX,xk+t*dk)));
                formatted_expr = strrep(formatted_expr, '.*', '.* ');
                formatted_expr = strrep(formatted_expr, '.^', '.^ ');

                %disp(formatted_expr)

                pmin = fminbnd(tet,0,mtk);
                vals = [tet(0), tet(pmin), tet(mtk)];
                ts = [0,pmin,mtk];

                [~, index] = min(vals);

                tk = ts(index);

                tmp.tk = tk;

                xk = xk+tk*dk;

                tmp.xNext = xk;

                tb = table();
                tb.('M') = categorical(sprintf("(%s)",join(RicOp.rationalCast(M),',')));
                tb.('H') = categorical(sprintf("(%s)",join(RicOp.rationalCast(H),',')));
                tb.('Direzione') = categorical(sprintf("(%s, %s)", RicOp.rationalCast(dk)));
                tb.('Max spostamento') = categorical(RicOp.rationalCast(mtk));
                tb.('φ(t)') = categorical(formatted_expr);
                tb.('Passo') = categorical(RicOp.rationalCast(tk));
                tb.('xk next') = categorical(sprintf("(%s, %s)", RicOp.rationalCast(xk)));

                disp(tb);

                res = [res,tmp];

            end

        end

        function gomory(f,A,b)
			% Taglio di Gomory
			% gomory(f,A,b)
			%
			% ⎧ min f'x
			% ⎨ Ax=b
			% ⎩ x>=0
			%
			% Esempio:
			% Usare il - per il max!
			% f = [-5 -14 0 0]
			% A = [
			% 	18 8 1 0;
			% 	14 18 0 1;
			% ] 
			% b = [55; 61]
			%
			% res = gomory(f,A,b)
            % 
            % Ricordarsi le variabili di scarto!
            % 
            % Written by AndJ

			x = linprog(f,[],[],A,b,f'*0,[],optimoptions('linprog','Display','none'));
            disp('x del rilassato continuo di Gomory')
            display(x)
			base = find(x~=0)';
			nbase = find(x==0)';
            display(base)
			xb = x(base);
            
			xn = x(nbase);

			Ab = A(:,base);

			An = A(:,nbase);
            % display(Ab)
            % display(An)
			As = Ab^-1*An;

            tb = table();
            tb.('Base') = categorical(sprintf("(%s)",join(RicOp.rationalCast(base),',')));
			tb.('Ab') = categorical(sprintf("(%s)",join(RicOp.rationalCast(Ab),',')));
            tb.('An') = categorical(sprintf("(%s)",join(RicOp.rationalCast(An),',')));
            tb.('As') = categorical(sprintf("(%s)",join(RicOp.rationalCast(As),',')));
            disp(tb);
			
			len = length(f);
			%n = length(xb);
			m = length(xn);

			xsy = sym('x',[len,1]);
			%xsyb = xsy(base);
			xsyn = xsy(nbase);
            
            eq1=A*xsy==b;
            
            %eq2 = subs(eq1, var, A(1,:));
            %eq2 = subs(eq1, var, A(2,:));
            
            %len1=length(b);
            len1=length(nonzeros(f));
            len2=length(f)-len1;

            for j=1:len2
                eq1(j)=isolate(eq1(j),xsy(len1+j));
            end

			eq = sym(zeros(len,1));

			i=0;
            for k=1:len
                if ismember(k,base)
                    i=i+1;
                    [numx, demx] = rat(xb(i));
                    if demx ~= 1

                        for j=1:m

                            [num, dem] = rat(As(i,j));
                            eq(k) = eq(k) + (mod(num,dem)/dem)*xsyn(j);
                        end

                        eq(k) = eq(k) >= mod(numx,demx)/demx;
                    end
                end
            end

            eq = simplify(eq);
            eq3 = subs(eq,lhs(eq1),rhs(eq1));
            eq3 = simplify(eq3);

            %res.x = x;
            %res.As = As;
            %res.eq = eq;
            
            T=array2table([x,(1:len)',eq, eq3],'VariableNames',["x","r","eq in variables of N","eq-substitution"]);
            
            disp(T)

            disp('eq in variables of N')
            disp(eq)

            disp('eq-substitution')
            disp(eq3)
    
            return;

        end

        function []=kAlbero(M,n0,lim)
            % k-albero di costo minimo
            % RicOp.kAlbero(M,n0,lim)
            %
            % M: Matrice degli archi e dei costi
            % n0: nodo di riferimento
            % lim: archi da escludere/inserire
            %
            % A := Sorgente
            % B := Destinazione
            % C := Costo
            %
            %		A B C
            % M = [ ↓ ↓ ↓
            %	    1 2 45;
            %       2 4 23
            %	  ]
            %
            % D := 1-> preso; 0 -> escluso
            %
            %  		  A B D
            % lim = [ ↓ ↓ ↓
            %		  1 2 1; <- arco preso
            %		  1 3 0; <- arco escluso
            %		]

            if nargin <= 2
                lim = zeros(0,3);
            else
                if ~all(or(ismember(lim(:,[1 2]),M(:,[1 2]),'rows'),ismember(lim(:,[2 1]),M(:,[1 2]),'rows')))
                    error("Gli archi %s non esistono.",join(compose("(%s)", join(string(lim(~or(ismember(lim(:,[1 2]),M(:,[1 2]),'rows'),ismember(lim(:,[2 1]),M(:,[1 2]),'rows')),[1,2])),',')),' '));
                end
            end

            accept = lim(find(lim(:,3)==1),[1,2]);
            reject = lim(lim(:,3)==0,[1,2]);

            nodi = unique(M(:,[1 2]));

            count = zeros(size(nodi));

            [gc,grps] = groupcounts(accept(:,1));
            pos = find(ismember(nodi,grps));
            count(pos) = count(pos) + gc;

            [gc,grps] = groupcounts(accept(:,2));
            pos = find(ismember(nodi,grps));
            count(pos) = count(pos) + gc;

            if any(count > 2)
                % impossibile
                v=-1;
                return
            end

            % rimuovo le righe reject
            M(ismember(M(:,[1,2]),reject(:,[1,2]), 'rows'),:) = [];

            count = zeros(size(nodi));

            [gc,grps] = groupcounts(M(:,1));
            pos = find(ismember(nodi,grps));
            count(pos) = count(pos) + gc;

            [gc,grps] = groupcounts(M(:,2));
            pos = find(ismember(nodi,grps));
            count(pos) = count(pos) + gc;

            if any(count < 2)
                % impossibile
                v=-1;
                return
            end

            archi = M(:,[1 2]);
            costi = M(:,3);

            if ~ismember(n0, nodi)
                error('Il nodo %d non esiste.', n0);
            end

            pos_n0 = find(or(ismember(archi(:,1),n0),ismember(archi(:,2),n0)));
            pos_t = find(and(~ismember(archi(:,1),n0),~ismember(archi(:,2),n0)));

            pos_force = find(or(ismember(archi, accept, 'rows'),ismember(archi, flip(accept), 'rows')));

            % modifico temporaneamente i costi degli archi da prendere a -1 per inserirli forsatamente
            M(pos_force,3) = -1;

            G = graph(M(:,1)', M(:,2)', M(:,3)');

            G_t = graph(string(M(pos_t,1)'), string(M(pos_t,2)'), M(pos_t,3)');

            % plot(G_t,'EdgeLabel',G_t.Edges.Weight);

            tree = minspantree(G_t);
            % plot(tree,'EdgeLabel',tree.Edges.Weight);

            [~, index] = sort(M(:,3));
            index = index(ismember(index,pos_n0));

            k_archi = M(index(1:2),:);

            k_tree = addedge(tree, string(k_archi(:,1)),string(k_archi(:,2)),k_archi(:,3));


            % ripristino i costi
            k_tree.Edges.Weight(findedge(k_tree,string(accept(:,1)),string(accept(:,2)))) = costi(pos_force);
            M(pos_force,3) = costi(pos_force);

            tab = k_tree.Edges;

            tab.('EndNodes') = categorical(compose("(%s)", join(string(tab.('EndNodes')))));
            disp(tab);

            % plot(k_tree,'EdgeLabel',k_tree.Edges.Weight);

            cyc = cyclebasis(k_tree);

            fprintf("Ciclo Hamiltoniano: %s\n", mat2str(size(cyc,1) == 1 & all(ismember(nodi,cell2mat(cellfun(@str2num,cyc{1},'un',0).')))));


            v = sum(tab.('Weight'));

            disp('Vincoli')
            disp(lim)
            disp(v)
            fprintf("Costo dell'albero di nodo %d: %d",n0,v)
            return;
        end

        function []=nodoPiuVicino(M,n0)
            % Algoritmo del nodo più vicino
            % RicOp.nodoPiuVicino(M,n0)
            %
            % M: Matrice degli archi e dei costi
            % n0: nodo di partenza
            %
            % A := Sorgente
            % B := Destinazione
            % C := Costo
            %
            %		A B C
            % M = [ ↓ ↓ ↓
            %	    1 2 45;
            %       2 4 23
            %	  ]

            nodi = unique(M(:,[1 2]));
            archi = M(:,[1 2]);
            costi = M(:,3);

            v = 0;

            ciclo = n0;

            nodo = n0;
            while length(nodi) ~= length(ciclo)

                pos_n = find(or(ismember(archi(:,1),nodo),ismember(archi(:,2),nodo)));
                [~,index] = sort(costi);
                index = index(ismember(index,pos_n));
                index = index(1);

                nodo = archi(index,archi(index,:)~=nodo);
                ciclo = [ciclo, nodo];
                v = v+costi(index);

                archi(pos_n,:) = [];
                costi(pos_n) = [];
                % M(pos_n,:) = [];

            end

            v = v + M(or(ismember(M(:,[1 2]),[n0,nodo],'rows'),ismember(M(:,[1 2]),[nodo,n0],'rows')),3);

            fprintf("(%s)\n", join(string(ciclo), ' - '));
            fprintf("Costo del ciclo hamiltoniano: %d",v)
            return;

        end

        function dijkstra(matrix,source)
            % Algoritmo di dijkstra
            % RicOp.dijkstra(matrix, source)
            %
            % matrix: Matrice degli archi e dei costi
            % source: nodo di partenza
            %
            % EXAMPLE
            %
            % A := Sorgente
            % B := Destinazione
            % C := Costo
            %
            %       A B C
            % G = [ ↓ ↓ ↓
            %       1 2 3;
            %       1 3 3;
            %       3 2 3;
            %       2 5 18;
            %       5 3 6;
            %       2 4 4;
            %       5 4 10;
            %       4 6 5;
            %       6 5 5;
            % ];
            % RicOp.dijkstra(G,1)

            nodi = unique(matrix(:,[1 2]));
            archi = matrix(:,[1 2]);
            costi = matrix(:,3);

            U = nodi;

            potenziale = zeros(size(nodi)) + inf;
            dest = zeros(size(nodi)) - 1;

            potenziale(nodi==source) = 0;
            dest(nodi==source) = 0;

            Q = [];

            while ~isempty(U)
                posN = find(nodi==U(1));

                for i=1:length(nodi)
                    if ismember(nodi(i),U) && potenziale(i) < potenziale(posN)
                        posN = i;
                    end
                end

                nodo = nodi(posN);

                archi_uscenti = archi(find(archi(:,1)==nodo)',:);

                Q = unique([Q;archi_uscenti(:,2)]);

                fprintf('Scelgo il nodo %d\n', nodo);

                fprintf('Forward star for Node %d: [', nodo);
                fprintf(' %d', archi_uscenti(:, 2));
                fprintf(' ]\n\n');

                for i=1:size(archi_uscenti,1)
                    [~,posArco] = ismember(archi_uscenti(i,:),archi,'rows');
                    [~,posNu] = ismember(archi_uscenti(i,2),nodi);
                    if potenziale(posNu) > potenziale(posN) + costi(posArco)
                        dest(posNu) = posN;
                        potenziale(posNu) = potenziale(posN) + costi(posArco);
                    end
                end

                tp = array2table([potenziale,dest],'VariableNames',["π","P"]);
                tp = mergevars(tp,["π","P"],'NewVariableName',sprintf("Nodo: %d",nodo),'MergeAsTable',true);
                tp.Properties.RowNames = string(nodi);
                disp(tp);


                U(U==nodo) = [];
                Q(~ismember(Q,U)) = [];

                % if isempty(Q)
                %     fprintf("Q: Ø\n")
                % else
                %     fprintf("Q: %s\n", join(string(Q'),','));
                % end
                if isempty(U)
                    fprintf("S: Ø\n")
                else
                    fprintf("S: %s\n", join(string(U'),','));
                end
                fprintf("\n\n");
            end

            K=[];

            for i=2:length(dest)
                    K=[K;dest(i) i];
                    %fprintf("%d %d\n",dest(i),i)
            end

            K=sortrows(K,1);
            index=(2:length(dest))';
            potenziale=potenziale(index,:);
            dest=dest(index,:);
            
            T=table(K,dest,index,potenziale,'VariableNames',["Archi sol. ottima" "P" "Nodo" "π" ]);
            disp(T)
        end


        function FordFulkerson(matrix,source,destination)
            % Algoritmo di FordFulkerson
            % RicOp.FordFulkerson(matrix, source, destination)
            %
            % matrix: Matrice degli archi e delle capacità
            % source: nodo di partenza
            % destination: nodo di destinazione
            %
            % EXAMPLE
            %
            % A := Sorgente
            % B := Destinazione
            % C := Capacità
            %
            %       A B C
            % G = [ ↓ ↓ ↓
            %       1 2 3;
            %       1 3 3;
            %       3 2 3;
            %       2 5 18;
            %       5 3 6;
            %       2 4 4;
            %       5 4 10;
            %       4 6 5;
            %       6 5 5;
            % ];
            % Nota:
            % le soluzioni (i-j) e (j-i) indicano una coppia di archi
            % del grafo residuo (esempio 1-2 e 2-1)
            % 
            % FordFulkerson(G,1,6)
            
            taglio.Ns = [];
            taglio.Nt = [];

            [cammino_aumentante_cell,cs,ct] = RicOp.camminoAumentante(matrix,source,destination);
            %disp(cammino_aumentante_cell)
            matrix = RicOp.castMatrixCapacity(matrix(:,1)', matrix(:,2)', matrix(:,3)');
            %capacita=matrix;
            tmp = matrix; % utilizzata in fase di stampa
            dim = length(matrix);
            residual_matrix = zeros(dim,dim);

            k=0;
            v = 0;
            counter=0;

            while true
                % cammino_aumentante = [];

                if(k<length(cammino_aumentante_cell))
                    k=k+1;
                else 
                    break;
                end
                cammino_aumentante=cammino_aumentante_cell{k};

                % if p(destination) == -1
                %     for i=1:length(p)
                %         if p(i) ~= -1
                %             taglio.Ns = [taglio.Ns,i];
                %         else
                %             taglio.Nt = [taglio.Nt,i];
                %         end
                %     end
                %     sort(taglio.Ns);
                %     sort(taglio.Nt);
                % 
                %     break % interrompo perchè non ci sono più cammini aumentanti
                % else
                %     % creo il cammino aumentante
                %     i = destination;
                %     cammino_aumentante = destination;
                %     while i ~= source
                %         i = p(i);
                %         cammino_aumentante = [i,cammino_aumentante];
                %     end
                % end
                %disp(cammino_aumentante)
                delta = inf;
                % trovo delta
                %disp(cammino_aumentante)
                for i=1:length(cammino_aumentante)-1
                    if matrix(cammino_aumentante(i),cammino_aumentante(i+1)) < delta
                        delta = matrix(cammino_aumentante(i),cammino_aumentante(i+1));

                    end
                end

                % disp('a')
                % disp(matrix)
                % disp('b')
                % disp(residual_matrix)
                % disp('-------')

				% aggiorno `matrix` e `residual_matrix`
                for i=1:length(cammino_aumentante)-1
                    matrix(cammino_aumentante(i),cammino_aumentante(i+1)) = matrix(cammino_aumentante(i),cammino_aumentante(i+1)) - delta;
                    matrix(cammino_aumentante(i+1),cammino_aumentante(i)) = matrix(cammino_aumentante(i+1),cammino_aumentante(i)) + delta;
                    residual_matrix(cammino_aumentante(i),cammino_aumentante(i+1)) = residual_matrix(cammino_aumentante(i),cammino_aumentante(i+1)) + delta;
                    residual_matrix(cammino_aumentante(i+1),cammino_aumentante(i)) = abs(residual_matrix(cammino_aumentante(i+1),cammino_aumentante(i)) - delta); % parte improvvisata
                end

                %matrix = matrix+residual_matrix';
                %residual_matrix = residual_matrix-triu(residual_matrix, -1)-triu(residual_matrix, -1)';
                
                % disp('c')
                % disp(matrix)
                % disp('d')
                % disp(residual_matrix)
                % disp('-------')

                sol = [];
                x=[];
                r=[];
                r1=[];
                
                
                % % Get the upper triangular part of the matrix
                % upper_triangular = triu(residual_matrix, 1);
                % 
                % % Get the lower triangular part of the matrix
                % lower_triangular = tril(residual_matrix, -1)';
                % %residual_matrix=upper_triangular-lower_triangular;
                
                for i=1:length(tmp)
                    for j=1:length(tmp)
                        if tmp(i,j) > 0 && i ~= j
                            sol = [sol,residual_matrix(i,j)];%-residual_matrix(j,i)]; % parte improvvisata
                            x=[x, residual_matrix(i,j), residual_matrix(j,i)];
                            r1=[r1, matrix(i,j)];
                            r=[r, matrix(i,j), matrix(j,i)];
                        end
                    end
                end

                v = v+delta;

                if(delta~=0)
                    counter=counter+1;
                    fprintf("Cammino aumentante ")
                    fprintf(" n°%d: ", counter)
                    fprintf("%-3d ", cammino_aumentante);
                    fprintf("\nδ: %d\n", delta);
                    fprintf("x(i,j): ")
                    fprintf("%-3d ", sol);
                    fprintf("\nr(i,j): ")
                    fprintf("%-3d ", r1)
                    fprintf("\n\nx(i,j)-x(j,i): ")
                    fprintf("%-3d ", x);
                    fprintf("\n\nr(i,j)-r(j,i): ")
                    fprintf("%-3d ", r);
                    fprintf("\n\nv: %d\n\n", v);
                end
            end

            % disp('c')
            % disp(matrix)
            % disp('d')
            % disp(residual_matrix)
            % disp('-------')

            fprintf("Ns: {");
            % fprintf("%d ", taglio.Ns);
            fprintf(" %d ", cs);
            fprintf("}\nNt: {");
            % fprintf("%d ", taglio.Nt);
            fprintf(" %d ", ct);
            fprintf("}\n");
        end

        function [] = pSimplex(f,A,b,base,iter)
            % Algoritmo del simplesso primale
            % RicOp.pSimplex(f,A,b,base,iter)
            %
            % f = funzione obbiettivo
            % A = matrice
            % b = valori noti
            % base = base di partenza
            % iter = numero di iterazioni
            %
            % ⎰ max f'*x
            % ⎱ A*x<=b
            %
            % EXAMPLE
            %
            % f = [-7 1]
            % A = [
            % 	-3 2;
            % 	-1 -3;
            % 	0 1;
            % 	3 2;
            % 	1 0;
            % 	2 -1;
            % ]
            % b = [4; -6; 5; 22; 6; 16]
            % base = [4 5]
            %
            % RicOp.pSimplex(f,A,b,base,2)

            %f=f';

            if length(f) ~= length(A(1,:))
                error("Il numero di colonne di `A` non corrisponde con `f`.");
            elseif length(b) ~= length(A(:,1))
                error("Il numero di righe di `A` non corrisponde con `b`.");
            end

            n_iter = 0; % Numero di iterazione

            tab = table('Size',[iter 9],'VariableTypes', ["categorical","categorical","categorical","categorical","categorical","categorical","categorical","categorical","categorical"],'VariableNames', ["Base", "x", "invAb", "y", "Degenere", "Indice Uscente", "A*Wh",  "Rapporti", "Indice Entrante"], 'RowNames', strcat("Iter ",string((1:iter)')));

            while iter > 0


                iter = iter - 1;
                n_iter = n_iter + 1;

                % fprintf("Iter %d.\n",n_iter);
                % tab.Properties.RowNames = sprintf("Iter %d",n_iter);
                % fprintf("Base: { ");
                tab(n_iter,1) = {categorical(sprintf("[%s]", join(string(base), ', ')))};
                % fprintf("%d ", base);
                % fprintf("}\n");

                Ab = A(base,:);
                invAb = Ab^-1;

                x = invAb*b(base);
                % fprintf("x: (%s)\n", join(RicOp.rationalCast(x),', '));
                tab(n_iter,2) = {categorical(sprintf("(%s)", join(RicOp.rationalCast(x),', ')))};

                %categorical(sprintf("(%s)",join(RicOp.rationalCast(invAb),',')));
                tab(n_iter,3) = {categorical(sprintf("(%s)",join(RicOp.rationalCast(invAb),',')));};

                y = zeros(length(b),1);
                y(base) = (f*invAb)';

                % fprintf("y: (%s)\n", join(RicOp.rationalCast(y),', '));
                tab(n_iter,4) = {categorical(sprintf("(%s)", join(RicOp.rationalCast(y),', ')))};

                if all(y>=0)
                    fprintf("Ottimo\n");
                    break
                end

                tmp = (A*x)-b;
                tmp(base) = [];
                % fprintf("Degenere: %d\n", ismember(0,tmp));
                tab(n_iter,5) = {categorical(ismember(0,tmp))};

                h = -1;
                for i=1:length(y)
                    if y(i) < 0
                        h=i;
                        break
                    end
                end
                % fprintf("Indice Uscente: %d\n",h);
                tab(n_iter,6) = {categorical(h)};

                Wh = [];
                for i=1:length(base)
                    if base(i) == h
                        Wh = -invAb(:,i);
                        break
                    end
                end

                testVoid = A*Wh;

                if all(testVoid<=0)
                    disp('P ha un valore ottimo +inf e D è vuoto')
                    break
                end

                %categorical(sprintf("(%s)",join(RicOp.rationalCast(testVoid),',')));
                tab(n_iter,7) = {categorical(sprintf("(%s)",join(RicOp.rationalCast(testVoid),',')));};

                teta = inf;
                rapportiTmp = zeros(1,length(b))-1;
                for i=1:length(b)
                    if testVoid(i) > 0 && ~ismember(i, base)
                        rapportiTmp(i) = (b(i)-A(i,:)*x)/testVoid(i);
                        if rapportiTmp(i) < teta
                            teta = rapportiTmp(i);
                        end
                    end
                end

                k = 0;
                for i=1:length(rapportiTmp)
                    if rapportiTmp(i) == teta
                        k=i;
                        break
                    end
                end

                rapporti = rapportiTmp(rapportiTmp > 0);

                % fprintf("Rapporti: %s\n", join(RicOp.rationalCast(rapporti),' '));
                tab(n_iter,8) = {categorical(join(RicOp.rationalCast(rapportiTmp),', '))};
                % fprintf("Indice Entrante: %d\n\n",k);
                tab(n_iter,9) = {categorical(k)};

                base = sort([base(base~=h),k]);
            end

            tab(n_iter+1:size(tab,1),:) = [];

            disp(tab);
        end

        % Algoritmo del simplesso duale

        function []=dSimplex(f,A,b,base,iter)
        % dSimplex(f,A,b,base,iter)
        %
        % f = funzione obbiettivo
        % A = matrice
        % b = valori noti
        % base = base di partenza
        % iter = numero di iterazioni
        %
        % ⎰ min f'*x
        % ⎱ A*x=b
        %
        % Esempio
        %
        % f = [3 -7 5 22 14 15]
        % A = [
        % 	-1 -1 0 3 2 2;
        % 	1 -4 1 2 1 -2;
        % ]
        % b = [2;1]
        % base = [4 6]
        %
        % RicOp.dSimplex(f,A,b,base,2)
        
        if length(f) ~= length(A(1,:))
            error("Il numero di colonne di `A` non corrisponde con `f`.");
        elseif length(b) ~= length(A(:,1))
            error("Il numero di righe di `A` non corrisponde con `b`.");
        end
        
        A=A';
        %disp(A)
        f=f';
        b=b';
        
        n_iter = 0; % Numero di iterazione
        
        tab = table('Size',[iter 10],'VariableTypes', ["categorical","categorical","categorical","categorical","categorical","categorical","categorical","categorical","categorical","categorical"],'VariableNames', ["Base", "x", "invAb", "y", "Degenere", "Residui", "Indice Entrante", "A*Wh","Rapporti", "Indice Uscente"], 'RowNames', strcat("Iter ",string((1:iter)')));
        
        while iter > 0
        
            iter = iter - 1;
            n_iter = n_iter + 1;
        
            % fprintf("Iter %d.\n",n_iter);
            % tab.Properties.RowNames = sprintf("Iter %d",n_iter);
            % fprintf("Base: { ");
            tab(n_iter,1) = {categorical(sprintf("[%s]", join(string(base), ', ')))};
            % fprintf("%d ", base);
            % fprintf("}\n");
        
            Ab = A(base,:);
            %disp(Ab)
            invAb = Ab^-1;
        
            x = invAb*f(base);
            % fprintf("x: (%s)\n", join(RicOp.rationalCast(x),', '));
            tab(n_iter,2) = {categorical(sprintf("(%s)", join(RicOp.rationalCast(x),', ')))};
        
            %categorical(sprintf("(%s)",join(RicOp.rationalCast(invAb),',')));
            tab(n_iter,3) = {categorical(sprintf("(%s)",join(RicOp.rationalCast(invAb),',')));};
        
            y = zeros(length(f),1);
            y(base) = (b*invAb)';
        
            % fprintf("y: (%s)\n", join(RicOp.rationalCast(y),', '));
            tab(n_iter,4) = {categorical(sprintf("(%s)", join(RicOp.rationalCast(y),', ')))};
        
            rapportiTmp = zeros(1,length(f))-1;
            for i=1:length(f)
                rapportiTmp(i) = (f(i)-A(i,:)*x)+0.001;
                if rapportiTmp(i) < 0 && ~ismember(i,base)
                    k = i;
                    rapportiTmp(i)=rapportiTmp(i)-0.001;
                    break;
                end
                rapportiTmp(i)=rapportiTmp(i)-0.001;
            end

            for i=1:length(f)
                if ismember(i,base)
                    rapportiTmp(i)=0;
                end
                if ~ismember(i,base)
                    rapportiTmp(i) = (f(i)-A(i,:)*x);
                end
            end

            tab(n_iter,6) = {categorical(join(RicOp.rationalCast(rapportiTmp),', '))};
            
            if rapportiTmp >= 0
                fprintf("Ottimo\n");
                break;
            end
        
            %disp(rapportiTmp);
            %disp(k);
        
            tmp = (A*x)-b;
            tmp(base) = [];
            % fprintf("Degenere: %d\n", ismember(0,tmp));
            tab(n_iter,5) = {categorical(ismember(0,tmp))};
        
            % fprintf("Indice Entrante: %d\n",h);
            tab(n_iter,7) = {categorical(k)};
        
            prodottiTmp=zeros(1,length(b))-1;
            %display(invAb);
            for i=1:length(base)
                Wh = -invAb(:,i);
                %display(Wh);
                prodottiTmp(i)=A(k,:)*Wh;
            end
        
            testVoid = prodottiTmp;
            if all(testVoid>=0)
                % D ha un valore ottimo -inf e P è vuoto
                break
            end
        
            %categorical(sprintf("(%s)",join(RicOp.rationalCast(testVoid),',')));
            tab(n_iter,8) = {categorical(sprintf("(%s)",join(RicOp.rationalCast(testVoid),',')));};
        
            rapportiTmp1=zeros(1,length(b))-1;
        
            teta = inf;
        
            j=y(base,:);
        
            %disp(j);
        
            %prodottiTmp = setdiff(prodottiTmp,0);
            %display(prodottiTmp)
        
            for i=1:length(base)
                rapportiTmp1(i)=-j(i)/prodottiTmp(i);
                if rapportiTmp1(i) < teta && rapportiTmp1(i)>=0
                    teta = rapportiTmp1(i);
                end
            end
        
            h = 0;
            for i=1:length(base)
                if rapportiTmp1(i) == teta
                    h=base(i);
                    %display(base(i))
                    break
                end
            end
        
            %display(h)
            %display(rapportiTmp1)
            % fprintf("Rapporti: %s\n", join(RicOp.rationalCast(rapporti),' '));
            tab(n_iter,9) = {categorical(join(RicOp.rationalCast(rapportiTmp1),', '))};
            % fprintf("Indice Uscente: %d\n\n",k);
            tab(n_iter,10) = {categorical(h)};
        
            base = sort([base(base~=h),k]);
        end
        
            tab(n_iter+1:size(tab,1),:) = [];
            
            disp(tab);
        end

        function flowSimplex(matrix,b,T,U,iter)
            % Algoritmo del simplesso su reti di costo minimo capacitate
            % RicOp.flowSimplex(matrix,b,T,U,iter)
            %
            % EXAMPLE
            %
            % matrix: Matrice degli archi, dei costi e delle capacità
            % b: valori nodi
            % T: albero di copertura
            % U: arco saturo
            % iter: numero iterazioni
            %
            % A := Sorgente
            % B := Destinazione
            % C := Costo
            % D := Capacità
            %
            %
            %       A B C D
            % G = [ ↓ ↓ ↓ ↓
            %       1 2 4 8;
            %       1 3 3 10;
            %       2 3 10 4;
            %       2 4 9 6;
            %       2 6 3 5;
            %       3 4 9 8;
            %       3 5 6 4;
            %       3 6 9 7;
            %       4 6 5 4;
            %       5 6 3 8;
            % ];
            % b = [-5; -3; -6; 2; 4; 8];
            % T = [1 2; 1 3; 2 6; 3 4; 3 5];
            % U = [2 3; 3 6];
            % RicOp.flowSimplex(G,b,T,U,2);

            matrix = sortrows(matrix);
            btot = b;
            b = b(2:end); % le equazioni sono linearmente dipendenti (una è in eccesso).

            cost = matrix(:,3)';
            capacity = matrix(:,4)';

            nodi = unique(matrix(:,[1 2]))';
            archi = matrix(:,[1 2]);

            n_nodi = length(nodi);
            n_archi = size(archi,1);

            n_iter = 0;

            % tiledlayout(2,1)


            % plot(graph,'Layout','force','EdgeLabel',weights,'LineWidth',ismember(archi, T,'rows')'*2+1,'ArrowSize',13);

            while iter > 0

                n_iter = n_iter + 1;
                iter = iter - 1;

                fprintf("\nIter %d\n", n_iter);
                fprintf("Archi di T:")
                fprintf(" (%s)", join(string(T),','));
                fprintf("\n");

                fprintf("Archi di U:")
                fprintf(" (%s)", join(string(U),','));
                fprintf("\n");

                E = zeros(n_nodi,n_archi);
                for i=1:n_nodi
                    for j=1:n_archi
                        if i == archi(j,1)
                            E(i,j) = -1;
                        elseif i == archi(j,2)
                            E(i,j) = 1;
                        else
                            E(i,j) = 0;
                        end
                    end
                end

                Etot = E;
                E = E(2:end,:); % le equazioni sono linearmente dipendenti (una è in eccesso).

                fprintf("Matrice di incidenza:\n");
                disp(array2table(E,'VariableNames',join(string(archi),'-'),'RowName',string(nodi(2:end))));
                fprintf("\n");

                posT = find(ismember(archi, T,'rows'));
                posU = find(ismember(archi, U,'rows'));

                Et = E(:,posT);
                Eu = E(:,posU);

                fprintf("Matrice di base:\n");
                disp(array2table(Et,'VariableNames',join(string(T),'-'),'RowName',string(nodi(2:end))));
                fprintf("\n");

                x = zeros(size(archi,1),1);
                if isempty(Eu)
                    x(posT) = Et^-1*b;
                else
                    x(posT) = Et^-1*(b-Eu*capacity(posU)');
                    x(posU) = capacity(posU);
                end

                is_zero_present = any((matrix(posT,4)-x(posT)) == 0);

                if is_zero_present || any((x(posT)) == 0)
                    disp('x degenere');
                else
                    disp('x non degenere');
                end

                fprintf("x: (%s)\n", join(RicOp.rationalCast(x),', '));

                potenziale = [0,cost(posT)*Et^-1];
                fprintf("π: (%s)\n", join(string(potenziale),', '));

                arco_entrante = -1;
                costi_ridotti = zeros(size(archi,1),1);
                for i=1:size(archi,1)
                    costi_ridotti(i) = cost(i) + potenziale(archi(i,1)) - potenziale(archi(i,2));
                    if arco_entrante == -1
                        if ismember(archi(i,:),U,'rows') && costi_ridotti(i) > 0
                            arco_entrante = archi(i,:);
                        elseif ~ismember(archi(i,:),T, 'rows') && ~ismember(archi(i,:),U,'rows') && costi_ridotti(i) < 0
                            arco_entrante = archi(i,:);
                        end
                    end
                end

                tab = array2table(costi_ridotti,'VariableNames',"Costi ridotti",'RowName',compose("(%s)",join(string(archi),',')));
                tab(posT,:)=[];
                disp(tab);
                % fprintf("\n");

                if arco_entrante == -1
                    % fprintf("Ottimo\n");
                    f = cost;
                    Aeq = Etot;
                    beq = btot;
                    ub = capacity';
                    lb = ub*0;

                    sol = linprog(f,[],[],Aeq,beq,lb,ub);
                    fprintf("x: (%s)\n", join(RicOp.rationalCast(sol),', '));

                    break
                end

                fprintf("Arco entrante: (%s)\n\n", join(string(arco_entrante), ','));

                ciclo = cell2mat(allcycles(graph([T(:,1);arco_entrante(1)], [T(:,2);arco_entrante(2)])));
                
                a=find(ismember(archi,arco_entrante,'rows'));

                posP = a;
                
                %posP = [];
                
                posM = [];
                
                dir = 0; % direzione
                lenC = length(ciclo);

                ciclo1 = zeros(length(ciclo)-1, 2);    
                for i = 1:(length(ciclo)-1)
                       ciclo1(i, :) = ciclo(i:i+1);
                end
                
                k=1; % bet that the arc is in the original cycle (ciclo 1)

                if(~ismember(arco_entrante,ciclo1,'rows')) % if it isn't
                    k=0; % bet failed
                end

                for i=1:lenC
                    if ismember([ciclo(i),ciclo(mod(i,lenC)+1)],T,'rows')
                    %if ismember([ciclo(i),ciclo(mod(i,lenC)+1)],[T;U],'rows')

                        j = find(ismember(archi, [ciclo(i),ciclo(mod(i,lenC)+1)],'rows'));
                        if(k)
                            posP = [posP,j]; %C+
                        else
                            posM = [posM,j]; %C-
                        end
                        %posP = [posM,j]; %C+
                    elseif ismember([ciclo(mod(i,lenC)+1),ciclo(i)],T,'rows')    
                    %elseif ismember([ciclo(mod(i,lenC)+1),ciclo(i)],[T;U],'rows')

                        j = find(ismember(archi, [ciclo(mod(i,lenC)+1),ciclo(i)],'rows'));
                        if(k)
                            posM = [posM,j]; %C-
                        else
                            posP = [posP,j]; %C+
                        end
                        %posM = [posM,j]; %C-
                    end

                end

                if ismember(arco_entrante,U,'rows')
                    dir = 1;
                end

                if dir == 1
                    tmp = posP;
                    posP = posM;
                    posM = tmp;
                end

                fprintf("C+:");
                fprintf(" (%s)", join(string(archi(posP,:)),','));
                fprintf("\n");
                fprintf("C-:");
                fprintf(" (%s)", join(string(archi(posM,:)),','));
                fprintf("\n");


                teta.p = min([inf;capacity(posP)'-x(posP)]);
                teta.m = min([inf;x(posM)]);

                fprintf("θ+: %d\n",teta.p);
                fprintf("θ-: %d\n",teta.m);

                tetaV = min(teta.p,teta.m);
                fprintf("θ: %d\n",tetaV);

                if tetaV == inf
                    fprintf("Il flusso di costo ottimo ha valore inf\n");
                    break
                end

                arco_uscente = [];

                for i=1:size(archi,1)
                    if ismember(i,posP)
                        if tetaV == capacity(i)-x(i)
                            arco_uscente = archi(i,:);
                            break
                        end
                    elseif ismember(i,posM)
                        if tetaV == x(i)
                            arco_uscente = archi(i,:);
                            break
                        end
                    end
                end

                fprintf("Arco uscente: (%s)\n", join(string(arco_uscente),','));

                % graph = digraph(archi(:,1),archi(:,2));
                weights = [];
                colors = [];
                style = [];
                for i=1:length(archi)
                    weights = [weights,sprintf("(%d,%d)",cost(i),capacity(i))];
                    if ismember(archi(i,:), arco_entrante,'rows')
                        style = [style;":"];
                        colors = [colors; 0 0 1];
                    elseif ismember(archi(i,:), T,'rows')
                        style = [style;"-"];
                        colors = [colors; 0 0 1];
                    elseif ismember(archi(i,:),U, 'rows')
                        style = [style;"-."];
                        colors = [colors; 1 0 0];
                    else
                        style = [style;"-"];
                        colors = [colors; 1 0 0];
                    end
                end

                % fig = nexttile;
                % plot(graph,'Layout','force','EdgeLabel',weights,'LineStyle',style,'EdgeColor',colors,'EdgeFontSize',10);
                % title(fig,sprintf("Iter %d",n_iter));


                if ~ismember(arco_entrante, [T;U], 'rows')
                    if ismember(arco_uscente, archi(posP,:))
                        if arco_entrante == arco_uscente
                            U = unique([U;arco_entrante],'rows');
                        else
                            T(all(T==arco_uscente,2),:) = [];
                            U = unique([U;arco_uscente],'rows');
                            T = unique([T;arco_entrante],'rows');
                        end
                    else
                        T(all(T==arco_uscente,2),:) = [];
                        T = unique([T;arco_entrante],'rows');
                    end
                else
                    if ismember(arco_uscente, archi(posM,:),'rows')
                        if arco_entrante == arco_uscente
                            U(all(U==arco_entrante,2),:) = [];
                        else
                            T(all(T==arco_uscente,2),:) = [];
                            U(all(U==arco_entrante,2),:) = [];
                            T = unique([T;arco_entrante],'rows');
                        end
                    else
                        %T(all(T==arco_entrante,2),:) = [];
                        %T(all(T==arco_uscente,2),:) = [];
                        %U(all(U==arco_entrante,2),:) = [];
                        %U(all(U==arco_uscente,2),:) = [];
                        T(all(T==arco_uscente,2),:) = [];
                        T = unique([T;arco_entrante],'rows');
                        U(all(U==arco_entrante,2),:) = [];
                        U = unique([U;arco_uscente],'rows');
                    end
                end
            end
        end
    end


    % UTILITY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    methods(Static, Access = private, Hidden)
        % Funzioni di utilità usate dalle funzioni pubbliche

        function ret = rationalCast(val)
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

        % function p = camminoAumentante(matrix,source,destination)
        %     % Trova un cammino aumentante da una matrice di adiacenza
        %     % Metodo di Edmonds-Karp
        %     p = zeros(1,length(matrix))-1;
        %     p(source) = 0;
        %     q = source;
        %     disp(matrix)
        %     while ~isempty(q)
        %         node = q(1);
        %         if node == destination
        %             break
        %         end
        % 
        %         q(1) = [];
        % 
        %         for i=1:size(matrix,2)
        %             if matrix(node,i) > 0 && p(i) == -1
        %                 q = [q,i];
        %                 p(i) = node;
        %             end
        %         end
        %     end
        % 
        %     return
        % end

        function [camminiAum,cs,ct]=camminoAumentante(matrix,s,d)

            % matrix(:,1)=[matrix(:,1);matrix(:,2)];
            % matrix(:,2)=[matrix(:,2);matrix(:,1)];
            % matrix(:,3)=[matrix(:,3);zeros(length(matrix),1)];
            
            matrix=[matrix;matrix(:,2), matrix(:,1), zeros(length(matrix),1)];
            
            G = digraph(matrix(:,1),matrix(:,2),matrix(:,3));
            
            camminiAum=allpaths(G,s,d);
            [~,~,cs,ct] = maxflow(G,s,d,'augmentpath');
            
            [~,I] = sort(cellfun(@length,camminiAum));
            camminiAum = camminiAum(I);
            
            %disp(camminiAum)

        end

        function [matrix] = castMatrixCapacity(start_node,end_node,capacity)
            % matrix = castMatrixCapacity(start_node,end_node,capacity)
            %
            % example
            % start_node = [1 1 3 2 5 2 5 4 6]
            % end_node = [2 3 2 5 3 4 4 6 5]
            % capacity = [3 3 3 18 6 4 10 5 5]
            %
            % matrix = castMatrixCapacity(start_node,end_node,capacity)
            % >>
            % 0              3              3              1/0            1/0            1/0
            % 1/0            0              1/0            4             18              1/0
            % 1/0            3              0              1/0            1/0            1/0
            % 1/0            1/0            1/0            0              1/0            5
            % 1/0            1/0            6             10              0              1/0
            % 1/0            1/0            1/0            1/0            5              0
            %---------------------------------------------------
            if length(start_node) ~= length(end_node) || length(end_node) ~= length(capacity)
                error("I vettori `start_node`, `end_node` e `capacity` devono avere la stessa dimensione.")
            end

            dim = max([start_node,end_node]);
            matrix = zeros(dim,dim);

            for i=1:dim
                matrix(i,i) = inf;
            end

            for i=1:length(capacity)
                matrix(start_node(i),end_node(i))=capacity(i);
            end
            return
        end

    end
end
