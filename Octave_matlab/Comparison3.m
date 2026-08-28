% Parameters
Nx = 100;
L = 2*pi;
x = linspace(0, L, Nx);
dx = x(2) - x(1);

T = 1;
lambda = 0.5;
dt = lambda * dx;
Nt = round(T / dt);
dt = T / Nt;
t = 0:dt:T;

% Initial condition
u0 = sin(x);
u_lw = u0;

% Store solution in time
U = zeros(Nt+1, Nx);  % Rows = time, columns = space
U(1, :) = u0;

% Time stepping (Lax-Wendroff)
for n = 1:Nt
    u_new = u_lw;
    u_new(1) = -sin(t(n+1));
    for j = 2:Nx-1
        u_new(j) = u_lw(j) ...
                 - 0.5*lambda*(u_lw(j+1) - u_lw(j-1)) ...
                 + 0.5*lambda^2*(u_lw(j+1) - 2*u_lw(j) + u_lw(j-1));
    end
    u_new(Nx) = u_new(Nx-1);  % Neumann BC
    u_lw = u_new;
    U(n+1, :) = u_lw;
end

% 3D surface plot
[XX, TT] = meshgrid(x, t);
figure;
surf(XX, TT, U, 'EdgeColor', 'none');
xlabel('x'); ylabel('t'); zlabel('u(x,t)');
title(sprintf('Lax-Wendroff dla \\lambda = %.2f, Nx = %d', lambda, Nx));
colormap jet;
view(135, 30);  % 3D angle
colorbar;
% Save to file
filename = sprintf('lw_solution_lambda_%.2f_Nx_%d.png', lambda, Nx);
filename = strrep(filename, '.', '_');  % Clean filename
print(filename, '-dpng', '-r300');     % PNG format, 300 dpi

close;  % Close figure to free memory
