for lambda = [0.25, 0.5, 0.75, 0.9]

  % Parametry
  Nx_list = [50, 100, 200, 400, 800, 1600];
  L = 2*pi;
  T = 1;

  fprintf('Running for lambda = %.2f\n', lambda);
  fprintf('%6s  %10s  %12s  %12s  %12s  %12s  %10s  %10s\n', ...
    'Nx', 'dx', 'L2Err LF', 'L2Err LW', 'MaxErr LF', 'MaxErr LW', 'Ratio A', 'Ratio F');


  for idx = 1:length(Nx_list)
      Nx = Nx_list(idx);
      x = linspace(0, L, Nx);
      dx = x(2) - x(1);
      dt = lambda * dx;
      Nt = floor(T / dt);
      dt = T / Nt;
      t = 0:dt:T;

      % Warunek początkowy
      u0 = sin(x);

      u_lf = u0;
      u_lw = u0;

      % Błąd średni
      err_acc_lf = 0;
      err_acc_lw = 0;
      count = 0;

      for n = 1:Nt
          % Faktyczne rozwiązanie równania
          u_exact = sin(x - t(n));

          % Błąd średni z drugiej połowy czasu
          if n > Nt/2
            err_acc_lf += sum((u_lf - u_exact).^2) * dx;
            err_acc_lw += sum((u_lw - u_exact).^2) * dx;
            count += 1;
          end

          if n < Nt
              % Lax-Friedrichs
              u_lf_new = u_lf;
              u_lf_new(1) = -sin(t(n+1));
              for j = 2:Nx-1
                  u_lf_new(j) = 0.5*(u_lf(j+1) + u_lf(j-1)) ...
                              - 0.5*lambda*(u_lf(j+1) - u_lf(j-1));
              end
              u_lf_new(Nx) = u_lf_new(Nx-1);
              u_lf = u_lf_new;

              % Lax-Wendroff
              u_lw_new = u_lw;
              u_lw_new(1) = -sin(t(n+1));
              for j = 2:Nx-1
                  u_lw_new(j) = u_lw(j) ...
                              - 0.5*lambda*(u_lw(j+1) - u_lw(j-1)) ...
                              + 0.5*lambda^2*(u_lw(j+1) - 2*u_lw(j) + u_lw(j-1));
              end
              u_lw_new(Nx) = u_lw_new(Nx-1);
              u_lw = u_lw_new;
          end
      end

      % Błędy średnie
      avg_err_lf = sqrt(err_acc_lf/count);
      avg_err_lw = sqrt(err_acc_lw/count);

      % Błędy na końcu
      final_err_lf = max(abs(u_lf - sin(x - T)));
      final_err_lw = max(abs(u_lw - sin(x - T)));

      % Porównanie błędów LF/LW
      ratio_avg = avg_err_lf / avg_err_lw;
      ratio_final = final_err_lf / final_err_lw;

      fprintf('%6d  %10.5f  %12.3e  %12.3e  %12.3e  %12.3e  %10.3f  %10.3f\n', ...
          Nx, dx, avg_err_lf, avg_err_lw, final_err_lf, final_err_lw, ratio_avg, ratio_final);

            % Plot: final numerical vs exact solution
      figure('visible', 'off');
      plot(x, u_lf, 'r-', 'LineWidth', 1.5); hold on;
      plot(x, u_lw, 'b--', 'LineWidth', 1.5);
      plot(x, sin(x - T), 'k:', 'LineWidth', 1.5);
      legend('Lax-Friedrichs', 'Lax-Wendroff', 'Exact');
      xlabel('x'); ylabel('u(x, T)');
      title(sprintf('Final solution at T = %.2f for Nx = %d, \\lambda = %.2f', T, Nx, lambda));
      grid on;
      % Construct filename (safe formatting)
      filename = sprintf('plot_lambda_%.2f_Nx_%d.png', lambda, Nx);
      filename = strrep(filename, '.', '_');  % Replace dots with underscores for portability

      % Save the plot
      print(filename, '-dpng', '-r300');  % PNG format, 300 dpi
  end
end
