function [r,ind] = rapporti(n,d)
% permette di calcolare i rapporti n/d ordinandoli per valore e salvando gli indici originali.
r = n./d;
ind = 1:length(r);
A = sortrows([r;ind].','descend');
A = A.';
r = A(1,:);
ind = A(2,:);
end

