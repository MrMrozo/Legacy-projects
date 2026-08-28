% Parameters
L = 2*pi;         % Spatial domain length
Nx = 200;         % Number of x points
x = linspace(0, L, Nx);
dx = x(2) - x(1);

T = 1;            % Total time
dt = 0.8 * dx;    % Time step (CFL < 1)
Nt = round(T / dt);
t = linspace(0, T, Nt);

% Initialize solution u(t, x)
u = zeros(Nt, Nx);

% Initial condition: u(0, x) = sin(x)
u(1, :) = sin(x);

% Time marching: upwind scheme
for n = 1:Nt-1
    % Boundary condition at x = 0
    u(n+1, 1) = -sin(t(n+1));  % u(t,0) = -sin(t)

    % Apply upwind scheme for rightward propagation
    for j = 2:Nx
        u(n+1, j) = u(n, j) - dt/dx * (u(n, j) - u(n, j-1));
    end
end

% Create 2D grids for plotting
[X, Tgrid] = meshgrid(x, t);

% Plot with surf
figure;
surf(X, Tgrid, u);   % X = x, Tgrid = t, u = u(t,x)
xlabel('x');
ylabel('t');
zlabel('u(t,x)');
title('Solution of the Advection Equation using Upwind Scheme');
shading interp;      % Smooth surface
colormap jet;        % Color scheme
colorbar;            % Show color scale
view(45, 30);        % 3D view angle

