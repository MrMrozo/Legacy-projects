alpha = 1 * pi * rand(20,1);
x0=7;
y0=3;
r=4;
sigma=.3;
x= x0 + r*cos(alpha) + normrnd(0,sigma,size(alpha));
y= y0 + r*sin(alpha) + normrnd(0,sigma,size(alpha));