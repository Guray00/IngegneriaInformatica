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
			% dijkstra(G,1)

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

				for i=1:size(archi_uscenti,1)
					[~,posArco] = ismember(archi_uscenti(i,:),archi,'rows');
					[~,posNu] = ismember(archi_uscenti(i,2),nodi);
					if potenziale(posNu) > potenziale(posN) + costi(posArco);
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

				if isempty(Q)
					fprintf("Q: Ø\n")
				else
					fprintf("Q: %s\n", join(string(Q'),','));
				end
				fprintf("\n\n");
			end
		end