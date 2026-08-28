% Time-Averaged Error Analysis: LF vs LW (with exact BCs, CFL=1, high resolution)

Nx_list = [50, 100, 200, 400, 800, 1600, 3200];
errors_lf = [];
errors_lw = [];
dx_list = [];
ratios = [];

T = 1;

for idx = 1:length(Nx_list)
    Nx = Nx_list(idx);
    L = 2*pi;
    x = linspace(0, L, Nx);
    dx = x(2) - x(1);
    dt = 0.5 * dx;                  % CFL = 1
    Nt = round(T / dt);
    t = linspace(0, T, Nt);
    lambda = dt / dx;

    % Initialize solutions
    u_lf = sin(x);
    u_lw = sin(x);

    % Accumulators for time-averaged error (only last 50% of time)
    err_acc_lf = 0;
    err_acc_lw = 0;
    count = 0;

    for n = 1:Nt
        % Exact solution at this time
        u_exact_n = sin(x - t(n));

        % Only average over last 50% of time steps
        if n > Nt / 2
            err_acc_lf += norm(u_lf - u_exact_n, 2)^2;
            err_acc_lw += norm(u_lw - u_exact_n, 2)^2;
            count += 1;
        end

        if n < Nt  % Skip update on last step
            % Lax-Friedrichs update
            u_lf_new = u_lf;
            u_lf_new(1) = -sin(t(n+1));
            for j = 2:Nx-1
                u_lf_new(j) = 0.5 * (u_lf(j+1) + u_lf(j-1)) ...
                            - 0.5 * lambda * (u_lf(j+1) - u_lf(j-1));
            end
            u_lf_new(Nx) = sin(x(Nx) - t(n+1));  % exact right BC
            u_lf = u_lf_new;

            % Lax-Wendroff update
            u_lw_new = u_lw;
            u_lw_new(1) = -sin(t(n+1));
            for j = 2:Nx-1
                u_lw_new(j) = u_lw(j) ...
                            - 0.5 * lambda * (u_lw(j+1) - u_lw(j-1)) ...
                            + 0.5 * lambda^2 * (u_lw(j+1) - 2*u_lw(j) + u_lw(j-1));
            end
            u_lw_new(Nx) = sin(x(Nx) - t(n+1));  % exact right BC
            u_lw = u_lw_new;
        end
    end

    % Final time-averaged L2 error
    avg_err_lf = sqrt(err_acc_lf / count) / sqrt(Nx);
    avg_err_lw = sqrt(err_acc_lw / count) / sqrt(Nx);
    error_ratio = avg_err_lf / avg_err_lw;

    % Store results
    errors_lf(end+1) = avg_err_lf;
    errors_lw(end+1) = avg_err_lw;
    dx_list(end+1) = dx;
    ratios(end+1) = error_ratio;

    % Print results
    fprintf('Nx = %4d | dx = %.5f | LF error = %.3e | LW error = %.3e | Ratio (LF/LW) = %.2f\n', ...
        Nx, dx, avg_err_lf, avg_err_lw, error_ratio);
end

% --- Plot time-averaged error ---
figure;
loglog(dx_list, errors_lf, 'b-o', 'LineWidth', 1.5, 'DisplayName', 'Lax-Friedrichs');
hold on;
loglog(dx_list, errors_lw, 'g-s', 'LineWidth', 1.5, 'DisplayName', 'Lax-Wendroff');
grid on;
xlabel('dx'); ylabel('Time-Averaged L2 Error');
title('Time-Averaged Error: Lax-Friedrichs vs Lax-Wendroff');
legend show;

% --- Optional: Plot error ratio ---
figure;
loglog(dx_list, ratios, 'm-d', 'LineWidth', 1.5);
xlabel('dx'); ylabel('LF / LW Error Ratio');
title('Error Ratio (Lax-Friedrichs / Lax-Wendroff)');
grid on;

