%% Function to solve bin packing with next fit
% Written by AndJ

function [] = bin_packing_nfd(items, V)

% items=[70 60 50 33 33 33 11 7 3]
% V=100
% items indica il vettore degli oggetti da inserire nei bin
% V indica la capacità dei bin

% do the actual work
binSize = V;
numItems = length(items);

items = sort(items, 'descend');

R = binSize * ones(numItems, 1); % there can not be more bins than items
assignment = zeros(numItems, 1);
currentBin = 1; % initialize the current bin

for i = 1:numItems
    if R(currentBin) >= items(i)
        assignment(i) = currentBin;
        R(currentBin) = R(currentBin) - items(i);
    else
        currentBin = currentBin + 1; % move to the next bin
        assignment(i) = currentBin;
        R(currentBin) = R(currentBin) - items(i);
    end
end

R = R(R < binSize);

vI=ceil(sum(items)/V);

disp("vI: ");
disp(vI);

% make a figure
figure
hold on
for i = 1:length(R)
    itemInds = find(assignment == i);
    sizes = items(itemInds);
    plot(i, cumsum(sizes), '*');
    text(i * ones(size(sizes)) + .1, cumsum(sizes), num2str(itemInds));
end

ylim([0 round(binSize*1.1)]);
plot([.5 length(R)+.5], [binSize binSize], '--');
xlim([.5, length(R)+.5]);
title("NFD");
set(gca, 'xtick', 1:length(R));
xlabel('Bin index');
ylabel('Fill');
end