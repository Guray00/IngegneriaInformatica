%% Funzione matlab che permette di trovare tutte le possibili basi ammissibili
% Written by AndJ

function []=findbasis(A,b)
% Il problema deve essere passato alla funzione
% in forma PRIMALE standard
% A*x<=b (tutti i vincoli devono essere espressi)
% oppure in forma DUALE standard A*x=B
% (tutti i vincoli devono essere espressi)

basis=lcon2vert(A,b);
% disp(basis)
C=round(A*basis');
[~,nC]=size(C);

% Initialize an empty cell array to store the common rows for each column
commonRowsPositions = cell(1, nC);
[~,colA]=size(A);

% Iterate over each column
for col = 1:nC
    % Find the common rows for the current column
    commonRowsPositions{col} = find(ismember(C(:, col), b),colA);
    if(C(:, col)==0)
        commonRowsPositions(col) = [];
    end    
end

commonRowsPositions(cellfun(@isempty,commonRowsPositions))=[];

for col = 1:length(commonRowsPositions)
    fprintf('Base ammissibile %d: %s\n', col, num2str(commonRowsPositions{col}));
end
%disp(commonRowsPositions')
% Combine common rows into a single column
allbasis = cell2mat(commonRowsPositions)';
allbasis = sortrows(allbasis);

% Calcolo della 'x'

[rows, cols]=size(allbasis);
sol=zeros(rows,cols);

number_basis=zeros(rows,1);
%number_basis(1)=nchoosek(rowA,colA);
%disp(number_basis)

for j=1:rows
    base=allbasis(j,:);
    Ab = A(base,:);
    invAb = Ab^-1;
    x = invAb*b(base);
    sol(j,:)=x';
end
sol=rats(sol);
%allbasis=[allbasis sol];

number_basis(1)=length(allbasis);

colnam ={'Base ammissibile' 'x' 'N° totale di basi'};

T=table(allbasis,sol,number_basis,'VariableName',colnam);

T.Index = (1:height(T))';
T = T(:,[4 1 2 3]);
T = renamevars(T,"Index","N°");

disp(T)

end