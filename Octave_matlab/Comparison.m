% Common setup
L = 2*pi;
Nx = 800;
x = linspace(0, L, Nx);
dx = x(2) - x(1);
T = 1;
dt = dx;
Nt = round(T / dt);
t = linspace(0, T, Nt);
lambda = dt/dx;

% Exact solution at final time
u_exact = sin(x - T);

% Helper function: Enforce BC at x = 0
bc = @(n) -sin(t(n+1));

% Initialize arrays
U_upwind = zeros(Nt, Nx);
U_lf     = zeros(Nt, Nx);
U_lw     = zeros(Nt, Nx);

% Initial condition
U_upwind(1,:) = sin(x);
U_lf(1,:)     = sin(x);
U_lw(1,:)     = sin(x);

% --- Upwind scheme ---
for n = 1:Nt-1
    U_upwind(n+1, 1) = bc(n);
    for j = 2:Nx
        U_upwind(n+1, j) = U_upwind(n, j) - lambda * (U_upwind(n, j) - U_upwind(n, j-1));
    end
end

% --- Lax-Friedrichs scheme ---
for n = 1:Nt-1
    U_lf(n+1, 1) = bc(n);
    for j = 2:Nx-1
        U_lf(n+1,j) = 0.5 * (U_lf(n,j+1) + U_lf(n,j-1)) ...
                      - 0.5 * lambda * (U_lf(n,j+1) - U_lf(n,j-1));
    end
    U_lf(n+1, Nx) = U_lf(n+1, Nx-1);  % Dummy BC
end

% --- Lax-Wendroff scheme ---
for n = 1:Nt-1
    U_lw(n+1, 1) = bc(n);
    for j = 2:Nx-1
        U_lw(n+1, j) = U_lw(n,j) ...
                     - 0.5 * lambda * (U_lw(n,j+1) - U_lw(n,j-1)) ...
                     + 0.5 * lambda^2 * (U_lw(n,j+1) - 2*U_lw(n,j) + U_lw(n,j-1));
    end
    U_lw(n+1, Nx) = U_lw(n+1, Nx-1);  % Dummy BC
end

% --- Error analysis at final time ---
u_up = U_upwind(end, :);
u_lf = U_lf(end, :);
u_lw = U_lw(end, :);

err_up = norm(u_up - u_exact, 2) / sqrt(Nx);
err_lf = norm(u_lf - u_exact, 2) / sqrt(Nx);
err_lw = norm(u_lw - u_exact, 2) / sqrt(Nx);

fprintf('L2 Error vs Exact Solution:\n');
fprintf('Upwind Scheme      : %.6f\n', err_up);
fprintf('Lax-Friedrichs     : %.6f\n', err_lf);
fprintf('Lax-Wendroff       : %.6f\n', err_lw);

% --- Plot final solutions ---
figure;
plot(x, u_exact, 'k--', 'LineWidth', 2, 'DisplayName', 'Exact');
hold on;
plot(x, u_up, 'r-', 'DisplayName', 'Upwind');
plot(x, u_lf, 'b-', 'DisplayName', 'Lax-Friedrichs');
plot(x, u_lw, 'g-', 'DisplayName', 'Lax-Wendroff');
xlabel('x'); ylabel('u(x,1)');
title('Comparison of Schemes at t = 1');
legend show; grid on;

