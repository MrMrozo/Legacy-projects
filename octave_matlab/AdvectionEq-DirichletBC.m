% Parameters
L = 2*pi;         % Length of domain in x
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
    u(n+1,1) = -sin(t(n+1));  % u(t,0) = -sin(t)

    % Apply upwind scheme for rightward propagation
    for j = 2:Nx
        u(n+1,j) = u(n,j) - dt/dx * (u(n,j) - u(n,j-1));
    end
end

% Plot final result
figure;
plot(x, u(1,:), 'k--', 'DisplayName', 'Initial Condition');
hold on;
plot(x, u(end,:), 'b-', 'DisplayName', sprintf('u(x,T=%.2f)', T));
xlabel('x'); ylabel('u');
title('Advection Equation with Dirichlet Boundary Condition');
legend show; grid on;

