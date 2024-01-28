% b = [-5 3 -2 -2 6]';
% edges = [
%     1 2 3 6
%     1 3 2 2
%     2 3 1 3
%     2 5 1 2
%     3 4 2 5
%     3 5 6 4
%     4 2 4 3
%     4 5 2 3
%     ];

% T = [
%     1 2
%     2 3
%     3 5
%     4 5
%     ];

% U = [
%     1 3
%     ];

% [flow, pot] = flowSimplex(b, edges, T, U)

function [flow, potential] = fSimplex(b, edges, T, U)

    % FLOWSIMPLEX
    %
    % b     supply/demand of nodes
    % edges matrix of the form [source, destination, cost, capacity]
    % T     edges in T partion [source, destination]
    % U     edges in U partion [source, destination]

    arguments
        b (:, 1)
        edges (:, 4)
        T (:, 2)
        U (:, 2)
    end

    assert(sum(b) == 0, "sum of balances must be 0")

    % ---------------------------------------------------------------------------- %
    %                                  basic info                                  %
    % ---------------------------------------------------------------------------- %

    edges = sortrows(edges);

    edge_ij = edges(:, 1:2);
    src = edges(:, 1);
    dst = edges(:, 2);
    cost = edges(:, 3);
    capacity = edges(:, 4);

    indexT = ismember(edge_ij, T, 'rows');
    indexU = ismember(edge_ij, U, 'rows');
    indexL = ~(indexT + indexU);

    partition = string(indexL);
    partition(indexT) = ' T     ';
    partition(indexU) = '   U   ';
    partition(indexL) = '     L ';

    edgeTable = table(edge_ij, src, dst, cost, capacity, partition);

    % ---------------------------------------------------------------------------- %
    %                               calculate base x                               %
    % ---------------------------------------------------------------------------- %

    fullgraph = digraph(src, dst, cost);
    E = sym(fullgraph.incidence);
    ET = E(:, indexT);
    EU = E(:, indexU);

    xbase = zeros(size(edges, 1), 1);
    xbase(indexT) = ET \ (b - EU * capacity(indexU));
    xbase(indexU) = capacity(indexU);

    flow = xbase;
    disp(['flow = ' toString(flow)]);

    edgeTable = addvars(edgeTable, flow);

    % ---------------
    % degenerate flow
    degenerate = any(flow(indexT) == 0 | flow(indexT) == capacity(indexT))
    degenerateFlow = indexT & ((flow == 0) | (flow == capacity));
    admissibleFlow = indexT & ((flow <= capacity) & (flow >= 0));
    admissibleFlow(~indexT) = true;

    degenerateFlowTable = table(edge_ij, flow, capacity, partition, admissibleFlow, degenerateFlow)

    % ---------------

    potential = [0, cost(indexT)' / ET(2:end, :)]';
    fprintf("potential = %s \n", toString(potential))

    reducedCost = cost + potential(src) - potential(dst);
    edgeTable = addvars(edgeTable, reducedCost);

    % add potential admissibility, degenerate...

    admissiblePotential = (indexL & reducedCost >= 0) | (indexU & reducedCost <= 0);
    admissiblePotential = logical(admissiblePotential);
    admissiblePotential(indexT) = true;

    degeneratePotential = (indexL & reducedCost == 0) | (indexU & reducedCost == 0);
    degeneratePotential = logical(degeneratePotential);
    degeneratePotential(indexT) = false;

    degeneratePotentialTable = table(edge_ij, reducedCost, partition, admissiblePotential, degeneratePotential)

    % ---------------------------------------------------------------------------- %
    %                               bellman condition                              %
    % ---------------------------------------------------------------------------- %

    if all(reducedCost(indexL) >= 0) ...
            && all(reducedCost(indexU) <= 0)
        % optimum found
        return
    end

    % ---------------------------------------------------------------------------- %
    %                                 entering edge                                %
    % ---------------------------------------------------------------------------- %

    L_not_bellman = edgeTable(logical(indexL & edgeTable.reducedCost < 0), :);
    U_not_bellman = edgeTable(logical(indexU & edgeTable.reducedCost > 0), :);
    not_bellman = sortrows(union(L_not_bellman, U_not_bellman));
    entering = not_bellman(1, :);

    % ---------------------------------------------------------------------------- %
    %                                  find cycle                                  %
    % ---------------------------------------------------------------------------- %

    graphT = digraph(src(indexT), dst(indexT), cost(indexT));
    cycledigraph = addedge(graphT, entering.src, entering.dst, entering.cost);

    [c_plus, c_minus] = findCycle(cycledigraph, [entering.edge_ij]);

    if strtrim(entering.partition) == "U"
        % discordant direction, so swapping C+ and C-
        [c_plus, c_minus] = deal(c_minus, c_plus);
    end

    % plot(cyclegraph)

    % ---------------------------------------------------------------------------- %
    %                         calculate theta, exiting edge                        %
    % ---------------------------------------------------------------------------- %

    c_plus_index = ismember(edgeTable.edge_ij, c_plus, "rows");
    c_minus_index = ismember(edgeTable.edge_ij, c_minus, "rows");

    edgeTable.cycle(:, 1) = "  ";
    edgeTable.cycle(c_plus_index) = "C+";
    edgeTable.cycle(c_minus_index) = "C-";

    edgeTable.theta(:, 1) = nan;
    edgeTable.theta(c_plus_index) = edgeTable{c_plus_index, "capacity"} - edgeTable{c_plus_index, "flow"};
    edgeTable.theta(c_minus_index) = edgeTable{c_minus_index, "flow"};

    theta_plus = min(edgeTable{c_plus_index, "theta"})
    theta_minus = min(edgeTable{c_minus_index, "theta"})

    theta = min([Inf theta_plus theta_minus]);

    if isinf(theta)
        "optimum is -Inf"
        return
    end

    theta_idx = (c_plus_index | c_minus_index) & (edgeTable.theta == theta);
    theta_edges = sortrows(edgeTable(theta_idx, :));
    exiting = theta_edges(1, :);

    % ---------------------------------------------------------------------------- %
    %                               update tripartion                              %
    % ---------------------------------------------------------------------------- %
    edgeTable.newPartition(:, 1) = strtrim(edgeTable.partition);

    entering_idx = edgeTable.src == entering.src & edgeTable.dst == entering.dst;
    exiting_idx = edgeTable.src == exiting.src & edgeTable.dst == exiting.dst;

    if strtrim(entering.partition) == "L"

        if exiting.cycle == "C+"

            if all(entering.edge_ij == exiting.edge_ij)
                edgeTable.newPartition(entering_idx) = "U";
                edgeTable.newPartition(exiting_idx) = "U";
            else
                edgeTable.newPartition(entering_idx) = "T";
                edgeTable.newPartition(exiting_idx) = "U";
            end

        elseif exiting.cycle == "C-"
            edgeTable.newPartition(entering_idx) = "T";
            edgeTable.newPartition(exiting_idx) = "L";
        end

    elseif strtrim(entering.partition) == "U"

        if exiting.cycle == "C-"

            if all(entering.edge_ij == exiting.edge_ij)
                edgeTable.newPartition(entering_idx) = "L";
                edgeTable.newPartition(exiting_idx) = "L";
            else
                edgeTable.newPartition(entering_idx) = "T";
                edgeTable.newPartition(exiting_idx) = "L";
            end

        elseif exiting.cycle == "C+"
            edgeTable.newPartition(entering_idx) = "T";
            edgeTable.newPartition(exiting_idx) = "U";
        end

    else
        "error"
    end

    entering
    exiting
    edgeTable

    newT = edgeTable.edge_ij(edgeTable.newPartition == "T", :)
    newU = edgeTable.edge_ij(edgeTable.newPartition == "U", :)

    fprintf("\n Paused, press any key to continue... \n");
    pause
    fprintf('================New Iter================\n');
    [flow, potential] = fSimplex(b, edges, newT, newU);

end

% ---------------------------------------------------------------------------- %
%                                    utility                                   %
% ---------------------------------------------------------------------------- %
function [c_plus, c_minus] = findCycle(cycleDigraph, entering)

    % find cycle by using undirected graph
    cycle_g = graph(cycleDigraph.adjacency + cycleDigraph.adjacency');
    cycle_path = cycle_g.allcycles;

    assert(length(cycle_path) == 1, "number of cycles != 0")

    % trick to find C+ and C- from the cycle node sequence
    cycle_path = cycle_path{1};
    src_nodes = cycle_path;
    dst_nodes = circshift(cycle_path, -1);

    cycle_edges = [src_nodes' dst_nodes'];

    if ~any(ismember(cycle_edges, entering, "rows"))
        cycle_edges = [dst_nodes' src_nodes'];
    end

    assert(any(ismember(cycle_edges, entering, "rows")), "error: entering index is not in the cycle")

    c_plus_index = cycleDigraph.findedge(cycle_edges(:, 1), cycle_edges(:, 2)) ~= 0;

    c_plus = cycle_edges(c_plus_index, :);
    c_minus = cycle_edges(~c_plus_index, [2 1]);

    % p = plot(cycleDigraph)
    % highlight(p, c_plus(:, 1), c_plus(:, 2))

end

function str = toString(x)
    str = sprintf("[ %s ]", join(string(x), " "));
end