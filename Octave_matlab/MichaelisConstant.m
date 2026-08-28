% 
%  data for calculating Michaelis constant
% 
% concentration of substract:
s = [0.25 	0.30 	0.40 	0.50 	0.70 	1.00 	1.40 	2.00]';
% production velocity:
v = [2.4 	2.6 	4.2 	3.8 	6.2 	6.4 	6.8 	7.4]';

% Linear approach:

X = 1. ./ s
Y = -1. ./ v
A=[X,Y];
b = -1*ones(size(X));
x = A \ b
Km = x(1);
a = x(2);

% linear fit:
figure(1);
plot(X,Y,'.')
title('Linear fit to 1/v vs. 1/s');
xlabel ("1/v");
ylabel ("1/x");
hold on
plot(X, -Km / a * X + b / a )
hold off

% actual curve using calculated ceofficients:
figure(2);
plot(s,v,'.')
title('Comparizon of real data with the curve obtained from linear approximation');
xlabel ("s");
ylabel ("v(s)");
hold on
plot(s, a .* s ./ (Km + s) )
legend("real v","calculated v")
hold off


