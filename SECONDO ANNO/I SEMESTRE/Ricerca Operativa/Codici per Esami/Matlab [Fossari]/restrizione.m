function retrizione(f, eqs, interval)
%Prese le parametrizzazioni di [x1 x2] in eqs, parametrizza f e disegna il grafico tra per valori di t in [a b].

% f = -x1^2 -2*x2^2+8*x2
% calcoliamo una parametrizzazione per g = x1^2 -x2 -2 --> x1=t, x2=t^2-2
% restrizione(f,[t, t^2 -2],[-1 3]) <-- otteniamo un grafico che
% rappresenta l'andamento della funzione lungo -1<=t<=3.

syms x1 x2 t;
% sostituiamo le parametrizzazioni in f
phi = subs(f, [x1, x2], [eqs(1), eqs(2)]);
disp('Substituted expression for f:');
phi

a = interval(1);
b = interval(2);

% Generate values for t in the specified interval
t_values = linspace(a - (b-a)*0.5, b + (b-a)*0.5, 500);  % You can adjust the number of points as needed

% Evaluate phi(t) for the generated t values
phi_values = subs(phi, t, t_values);

% Plot the function
hold on;
xline(a, 'k--', 'LineWidth', 1.5);  % Vertical line at x=a
xline(b, 'k--', 'LineWidth', 1.5);  % Vertical line at x=b
plot(t_values, phi_values, 'LineWidth', 2);
point_a = [a, subs(phi, t, a)];
point_b = [b, subs(phi, t, b)];
plot(point_a(1), point_a(2), 'ro', 'MarkerSize', 10);
plot(point_b(1), point_b(2), 'ro', 'MarkerSize', 10);
xlabel('t');
ylabel('\phi(t)');
title('Plot of \phi(t)');
grid on;

end
