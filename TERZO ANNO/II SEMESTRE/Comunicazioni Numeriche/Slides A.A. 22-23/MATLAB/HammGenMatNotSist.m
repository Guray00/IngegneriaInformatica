function [n,k,H,G] = HammGenMatNotSist(m)
% Hamming code non sistematico
% dato m genero i parametri n, k del codice
n = 2^m-1;
k = 2^m-m-1;


H = zeros(m,n);

%% matrice di controllo di parita' in forma NON sistematica
% genero le colonne della matrice di parita'
for l = 1:n
    
    H(:,l) = int2bit(l,n-k,0).';
    
end
% inizialmente la matrice generatrice  e' vuota
G = [];
gRank = 0;

for l = 1:2^n-1
    % genero una parola di n cifre a caso che non sia quella di tutti 0
    testWord = de2bi(l,n);
    s = mod(testWord*H',2);
    
    % if s = 0 => testword e' una parola di codice e la posso usare per la
    % matrice G (a patto che sia lin. indip. dalle altre righe di G)
    if sum(s) == 0
        % provo ad aggiungere testWord a G
        gMatTest = [G;testWord];
        % se il rango di G cresce => ok
        if gfrank(gMatTest,2)>gRank
            G = gMatTest;
            gRank = gRank+1;
            if gRank == k
                
                break
            end
        end
    end
end
    
    s = mod(G*H',2);
    
    
end


    function d = hamDist(x,y)
        % trovo le posizioni in cui i due vettori sono diversi.
        notEq = x~=y;
        % sommo lungo ciascuna riga: il risultato e' il numero di posizioni diverse
        % per riga
        d = sum(notEq,2);
    end