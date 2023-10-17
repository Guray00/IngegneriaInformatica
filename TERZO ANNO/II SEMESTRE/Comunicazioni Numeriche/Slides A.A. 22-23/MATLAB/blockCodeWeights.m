    function [Aw,xMat] = blockCodeWeights(G)
    
    [k,n] = size(G); %#ok<ASGLU> 
    
    %% Genero tutte le possibili parole di codice
    % matrice di tutte le sequenze di bit non codificate
    uMat = zeros(2^k,k);
    for l = 0:2^k-1
        uMat(l+1,:) = int2bit(l,k).';
    end
    
    % matrice di tutte le parole di codice
    xMat = mod(uMat*G,2);
    
    %% Calcolo la disribuzione dei pesi
    % generica parola di riferimento
    refCodeWord = xMat(10,:);
    
    % costruisco una matrice in cui ad ogni riga ho refCodeWord
    refMat = repmat(refCodeWord,2^k,1);
    % calcolo la distanza di Hamming
    distVect = hamDist(xMat,refMat);
    distVectSort = sort(distVect);
    
    [distValues, distPos] = unique(distVectSort);
    
    for ind = 1:length(distPos)-1
        Aw(ind,1) = distValues(ind);
        Aw(ind,2) = distPos(ind+1)-distPos(ind);
    end
    Aw(ind+1,1) = distValues(ind+1);
    Aw(ind+1,2) = 2^k+1-distPos(ind+1);
    end
    
    function d = hamDist(x,y)
        % trovo le posizioni in cui i due vettori sono diversi.
        notEq = x~=y;
        % sommo lungo ciascuna riga: il risultato e' il numero di posizioni diverse
        % per riga
        d = sum(notEq,2);
    end