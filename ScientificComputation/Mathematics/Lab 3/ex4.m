A4 = [10, -2, -1;
      -2, 10, -1;
      -1, -1, 10];
b4 = [3; 15; 27];
x0_4 = [0; 0; 0];
tol4 = 1e-6;
maxIter4 = 1000;
n4 = 3;

% ----- Jacobi Method -----
fprintf('\nJacobi Method:\n');
x_jac = x0_4;
err_jac = [];
for iter = 1:maxIter4
    x_new = zeros(n4,1);
    for i = 1:n4
        sum = 0;
        for j = 1:n4
            if j ~= i
                sum = sum + A4(i,j) * x_jac(j);
            end
        end
        x_new(i) = (b4(i) - sum) / A4(i,i);
    end
    err_jac(iter) = norm(x_new - x_jac, inf);
    if err_jac(iter) < tol4
        fprintf('Converged after %d iterations\n', iter);
        x_jac = x_new;
        break;
    end
    x_jac = x_new;
end
fprintf('Solution: I1 = %.6f, I2 = %.6f, I3 = %.6f\n', x_jac(1), x_jac(2), x_jac(3));

% ----- Gauss–Seidel Method -----
fprintf('\nGauss–Seidel Method:\n');
x_gs = x0_4;
err_gs = [];
for iter = 1:maxIter4
    x_old = x_gs;
    for i = 1:n4
        sum = 0;
        for j = 1:n4
            if j < i
                sum = sum + A4(i,j) * x_gs(j);      % use updated values
            elseif j > i
                sum = sum + A4(i,j) * x_old(j);     % use old values
            end
        end
        x_gs(i) = (b4(i) - sum) / A4(i,i);
    end
    err_gs(iter) = norm(x_gs - x_old, inf);
    if err_gs(iter) < tol4
        fprintf('Converged after %d iterations\n', iter);
        break;
    end
end
fprintf('Solution: I1 = %.6f, I2 = %.6f, I3 = %.6f\n', x_gs(1), x_gs(2), x_gs(3));

% ----- Convergence plot -----
figure;
semilogy(1:length(err_jac), err_jac, 'b-o', 'LineWidth', 1.5); hold on;
semilogy(1:length(err_gs), err_gs, 'r-s', 'LineWidth', 1.5);
xlabel('Iteration');
ylabel('||x^{(k+1)} - x^{(k)}||');
title('Convergence: Jacobi vs. Gauss–Seidel');
legend('Jacobi', 'Gauss–Seidel');
grid on;
