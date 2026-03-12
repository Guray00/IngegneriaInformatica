function [res] = LKKT_nonMio(f,g,h)
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
        error("Inserire la funzione obiettivo.");
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

    syL = sym('L', size(g));
    syM = sym('M', size(h));
    syX = symvar([f;g;h]);
    % disp(syX)
    eqs = sym(zeros(length(syX), 1));
    for i = 1 : length(syX)
        eqs(i) =  diff(f, syX(i));
    end
    
    for i=1:size(g,1)
        gradgi = [];
        for j = 1 : length(syX)
            gradgi = [gradgi; diff(g(i), syX(j))];
        end
        eqs = eqs + syL(i)*gradgi;
    end
    for i=1:size(h,1)
        gradhi = [];
        for j = 1 : length(syX)
            gradhi = [gradhi; diff(h(i), syX(j))];
        end
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

    for i=1:size(res.x, 1)
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
        elseif all(eigenv < 0)
            type=[type; "Massimo locale"];
        else
            type=[type; "Sella"];
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
    type(indexOfMin)="Minimo Globale";

    maxValue = max(res.fo);
    indexOfMax = res.fo == maxValue;
    type(indexOfMax)="Massimo Globale";

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