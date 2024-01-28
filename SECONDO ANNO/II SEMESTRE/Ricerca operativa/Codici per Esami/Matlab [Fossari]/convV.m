function A = convV(vertici)
%Dati dei vertici in R^2 che descrivono un poliedro ne estrapola le rette che fanno da vincoli al poliedro.
[m n] = size(vertici);
if n > 2
    error("La funzione lavora su R^2.")
end
% Trova i vincoli che generano il poliedro
indici_vertici_convessi = convhull(vertici);

for i = 1 : length(indici_vertici_convessi)
    vertices(i,1:2) =  vertici(indici_vertici_convessi(i),1:2);
end
figure
hold on
for i = 1 : length(indici_vertici_convessi) - 1
point1 = vertices(i,:);
point2 = vertices(i+1,:);

% Calculate the slope (m)
m(i) = (point2(2) - point1(2)) / (point2(1) - point1(1));

% Calculate the y-intercept (q)
q(i) = point1(2) - m(i) * point1(1);

dati(i,:) = [m(i) q(i) i];
text((vertices(i,1) + vertices(i+1,1)) / 2, (vertices(i,2) + vertices(i+1,2)) / 2, num2str(dati(i,3)), 'HorizontalAlignment', 'center');
end
% Display the results
for i = 1: length(dati)
    fprintf('(%d) y = %.2fx + %.2f\n', dati(i,3), dati(i,1), dati(i,2));
end

% Extract x and y coordinates
x = vertices(:, 1);
y = vertices(:, 2);

% Plot the vertices
plot(x, y, 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
xlabel('X-axis');
ylabel('Y-axis');
title('Plot of Vertices');
grid on;
end

