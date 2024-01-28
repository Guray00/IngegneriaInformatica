function x_optimal = syms2Q(f,A, b, Aeq, beq,lb,ub)
% Svolge quadprog utilizzando una funzione obiettivo f espressa in maniera simbolica.
% Define symbolic variables
syms x1 x2

% Create the Hessian matrix and linear coefficient vector
H = hessian(f, [x1, x2]);
f_linear = jacobian(f, [x1, x2]);

% Convert symbolic expressions to MATLAB functions
H_function = matlabFunction(H, 'Vars', {[x1, x2]});
f_linear_function = matlabFunction(f_linear, 'Vars', {[x1, x2]});

% Example values for demonstration
x_values = [2; 3];

% Evaluate the Hessian matrix and linear coefficient vector at x_values
H_evaluated = H_function(x_values(1), x_values(2));
f_linear_evaluated = f_linear_function(x_values(1), x_values(2));

% Use the matrices in quadprog
x_optimal = quadprog(H_evaluated, f_linear_evaluated, [], [], [], [], [], []);
end