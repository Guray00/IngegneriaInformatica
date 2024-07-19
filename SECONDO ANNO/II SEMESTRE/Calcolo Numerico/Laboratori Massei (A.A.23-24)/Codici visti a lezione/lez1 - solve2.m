function [x1, x2] = solve2(a, b, c)
if b>0
	x1 = (-b-sqrt(b^2-4*a*c))/(2*a);
else
	x1 = (-b+sqrt(b^2-4*a*c))/(2*a);	
end
x2 = c/(a*x1);
end
