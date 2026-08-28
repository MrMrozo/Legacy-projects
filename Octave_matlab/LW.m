% Parameters
L = 2*pi;
Nx = 200;
x = linspace(0, L, Nx);
dx = x(2) - x(1);

T = 1;
dt = 0.5 * dx;     % CFL condition: dt/dx <= 1
Nt = round(T / dt);
t = linspace(0, T, Nt);
lambda = dt/dx;

% Reuse parameters from above
u = zeros(Nt, Nx);
u(1, :) = sin(x);  % Initial condition

% Time integration (Lax-Wendroff)
for n = 1:Nt-1
    u(n+1,1) = -sin(t(n+1));  % Dirichlet BC at x = 0
    for j = 2:Nx-1
        u(n+1,j) = u(n,j) ...
                  - 0.5*lambda*(u(n,j+1) - u(n,j-1)) ...
                  + 0.5*lambda^2*(u(n,j+1) - 2*u(n,j) + u(n,j-1));
    end
    u(n+1,Nx) = u(n+1,Nx-1);  % Dummy BC at x = 2π
end

% Plot using surf
[X, Tgrid] = meshgrid(x, t);
figure;
surf(X, Tgrid, u);
xlabel('x'); ylabel('t'); zlabel('u(t,x)');
title('Lax-Wendroff Scheme for Advection Equation');
shading interp; colormap jet; colorbar;
view(45, 30);

