
clear; close all; clc;

%% ========================================================================
%  MATLAB SCRIPT: Solution of Systems of Linear and Nonlinear Equations
%  ========================================================================

%% q1: Gaussian Elimination (naive) with augmented matrix display
%  System:
%    2x - y +  z =  8
%   -3x - y + 2z = -11
%   -2x + y + 2z = -3
% -------------------------------------------------------------------------
A1 = [2, -1, 1; -3, -1, 2; -2, 1, 2];
b1 = [8; -11; -3];
n = length(b1);
Aug = [A1, b1];
disp('Initial augmented matrix:');
disp(Aug);

% Forward elimination
for k = 1:n-1
    for i = k+1:n
        m = Aug(i,k) / Aug(k,k);
        Aug(i,:) = Aug(i,:) - m * Aug(k,:);
    end
    fprintf('\nAfter elimination step k = %d:\n', k);
    disp(Aug);
end

% Back substitution
x = zeros(n,1);
x(n) = Aug(n,end) / Aug(n,n);
for i = n-1:-1:1
    x(i) = (Aug(i,end) - Aug(i,i+1:n)*x(i+1:n)) / Aug(i,i);
end
fprintf('\nSolution:\n'); disp(x);

%% q2: Gaussian Elimination without and with partial pivoting
%  System:
%    1e-5 x + y + z = 2
%    x + y + z = 3
%    x + 2y + 3z = 6
% -------------------------------------------------------------------------
A2 = [1e-5, 1, 1; 1, 1, 1; 1, 2, 3];
b2 = [2; 3; 6];
n2 = 3;

% --- Without pivoting (naive) ---
fprintf('\n=== Without pivoting ===\n');
Aug2 = [A2, b2];
for k = 1:n2-1
    for i = k+1:n2
        m = Aug2(i,k) / Aug2(k,k);
        Aug2(i,:) = Aug2(i,:) - m * Aug2(k,:);
    end
end
x2_no = zeros(n2,1);
x2_no(n2) = Aug2(n2,end) / Aug2(n2,n2);
for i = n2-1:-1:1
    x2_no(i) = (Aug2(i,end) - Aug2(i,i+1:n2)*x2_no(i+1:n2)) / Aug2(i,i);
end
fprintf('Solution:\n'); disp(x2_no);

% --- With partial pivoting ---
fprintf('\n=== With partial pivoting ===\n');
Aug2p = [A2, b2];
for k = 1:n2-1
    % Pivot: find row with largest |a_{ik}|
    [~, p] = max(abs(Aug2p(k:n2, k)));
    p = p + k - 1;
    if p ~= k
        Aug2p([k p], :) = Aug2p([p k], :);
        fprintf('Swap rows %d and %d:\n', k, p);
        disp(Aug2p);
    end
    for i = k+1:n2
        m = Aug2p(i,k) / Aug2p(k,k);
        Aug2p(i,:) = Aug2p(i,:) - m * Aug2p(k,:);
    end
end
x2_p = zeros(n2,1);
x2_p(n2) = Aug2p(n2,end) / Aug2p(n2,n2);
for i = n2-1:-1:1
    x2_p(i) = (Aug2p(i,end) - Aug2p(i,i+1:n2)*x2_p(i+1:n2)) / Aug2p(i,i);
end
fprintf('Solution:\n'); disp(x2_p);

%% q3: Gauss–Jacobi method with iteration table
%  System:
%    10x - y + 2z      = 6
%    -x + 11y - z + 3w = 25
%    2x - y + 10z - w  = -11
%    3y - z + 8w       = 15
%  Initial guess: (0,0,0,0), tolerance 1e-4
% -------------------------------------------------------------------------
A3 = [10, -1, 2, 0; -1, 11, -1, 3; 2, -1, 10, -1; 0, 3, -1, 8];
b3 = [6; 25; -11; 15];
x0 = zeros(4,1);
tol = 1e-4;
maxIter = 1000;

[x_jac, iter_jac, table_jac, err_jac] = jacobi_method(A3, b3, x0, tol, maxIter);
fprintf('\n=== Jacobi method ===\n');
fprintf('Converged after %d iterations\n', iter_jac);
fprintf('Solution:\n'); disp(x_jac);
fprintf('\nIteration table (first 10 rows):\n');
disp(table_jac(1:min(10,end), :));

%% q4: Electrical network – Jacobi vs. Gauss–Seidel with convergence plot
%  System:
%    10I1 - 2I2 - I3 = 3
%   -2I1 + 10I2 - I3 = 15
%   -I1 - I2 + 10I3 = 27
% -------------------------------------------------------------------------
A4 = [10, -2, -1; -2, 10, -1; -1, -1, 10];
b4 = [3; 15; 27];
x0_4 = zeros(3,1);
tol4 = 1e-6;
maxIter4 = 1000;

% Jacobi
[x_jac4, iter_jac4, ~, err_jac4] = jacobi_method(A4, b4, x0_4, tol4, maxIter4);
fprintf('\n=== Electrical network (Jacobi) ===\n');
fprintf('Converged after %d iterations\n', iter_jac4);
fprintf('I1 = %.6f, I2 = %.6f, I3 = %.6f\n', x_jac4);

% Gauss–Seidel
[x_gs4, iter_gs4, err_gs4] = gauss_seidel_method(A4, b4, x0_4, tol4, maxIter4);
fprintf('\n=== Electrical network (Gauss–Seidel) ===\n');
fprintf('Converged after %d iterations\n', iter_gs4);
fprintf('I1 = %.6f, I2 = %.6f, I3 = %.6f\n', x_gs4);

% Convergence plot
figure;
semilogy(1:iter_jac4, err_jac4, 'b-o', 'LineWidth', 1.5); hold on;
semilogy(1:iter_gs4, err_gs4, 'r-s', 'LineWidth', 1.5);
xlabel('Iteration'); ylabel('||x^{(k+1)} - x^{(k)}||');
title('Convergence: Jacobi vs. Gauss–Seidel');
legend('Jacobi', 'Gauss–Seidel');
grid on;

%% q5: Newton–Raphson for 2D nonlinear system
%  System:
%    x^2 + y^2 - 9 = 0
%    x - y - 1 = 0
%  Initial guess: (2,1)
% -------------------------------------------------------------------------
F5 = @(X) [X(1)^2 + X(2)^2 - 9; X(1) - X(2) - 1];
J5 = @(X) [2*X(1), 2*X(2); 1, -1];
x0_5 = [2; 1];
idek = 1e-6;
[x5, iter5, hist5] = newton_method(F5, J5, x0_5, idek);
fprintf('\n=== Newton–Raphson (x^2+y^2=9, x-y=1) ===\n');
fprintf('Converged after %d iterations\n', iter5);
fprintf('x = %.8f, y = %.8f\n', x5(1), x5(2));
disp('Iteration history:'); disp(hist5);

%% q6: Newton–Raphson for 3D nonlinear system
%  System:
%    x + y + z - 3 = 0
%    x^2 + y^2 + z^2 - 5 = 0
%    x - y + z - 1 = 0
%  Initial guess: (1,1,1)
% -------------------------------------------------------------------------
F6 = @(X) [X(1)+X(2)+X(3)-3; X(1)^2+X(2)^2+X(3)^2-5; X(1)-X(2)+X(3)-1];
J6 = @(X) [1, 1, 1; 2*X(1), 2*X(2), 2*X(3); 1, -1, 1];
x0_6 = [0.5;0.5;2];
idek = 1e-6;
[x6, iter6, hist6] = newton_method(F6, J6, x0_6, idek);
fprintf('\n=== Newton–Raphson (3D system) ===\n');
fprintf('Converged after %d iterations\n', iter6);
fprintf('x = %.8f, y = %.8f, z = %.8f\n', x6(1), x6(2), x6(3));
disp('Iteration history:'); disp(hist6);

%% q7: Newton–Raphson for cable tensions
%  System:
%    sin(x) + y^2 = 1
%    x^2 + y = 2
%  Initial guess: (1,1)
% -------------------------------------------------------------------------
F7 = @(X) [sin(X(1)) + X(2)^2 - 1; X(1)^2 + X(2) - 2];
J7 = @(X) [cos(X(1)), 2*X(2); 2*X(1), 1];
x0_7 = [1;1];
idek = 1e-6;
[x7, iter7, hist7] = newton_method(F7, J7, x0_7, idek);
fprintf('\n=== Newton–Raphson (cable tensions) ===\n');
fprintf('Converged after %d iterations\n', iter7);
fprintf('x = %.8f, y = %.8f\n', x7(1), x7(2));
disp('Iteration history:'); disp(hist7);

fprintf('\nAll exercises completed.\n');

% =========================================================================
%                        HELPER FUNCTIONS
% =========================================================================

function [x, iter, table, err] = jacobi_method(A, b, x0, tol, maxIter)
    n = length(b);
    x = x0;
    table = zeros(0, n+1);
    err = [];
    for iter = 1:maxIter
        x_new = zeros(n,1);
        for i = 1:n
            sum_ = A(i,:)*x - A(i,i)*x(i);
            x_new(i) = (b(i) - sum_) / A(i,i);
        end
        table(iter,:) = [iter, x_new'];
        err(iter) = norm(x_new - x, inf);
        if err(iter) < tol
            x = x_new;
            return;
        end
        x = x_new;
    end
    warning('Jacobi did not converge within maxIter');
end

function [x, iter, err] = gauss_seidel_method(A, b, x0, tol, maxIter)
    n = length(b);
    x = x0;
    err = [];
    for iter = 1:maxIter
        x_old = x;
        for i = 1:n
            sum_ = A(i,1:i-1)*x(1:i-1) + A(i,i+1:n)*x_old(i+1:n);
            x(i) = (b(i) - sum_) / A(i,i);
        end
        err(iter) = norm(x - x_old, inf);
        if err(iter) < tol
            return;
        end
    end
    warning('Gauss–Seidel did not converge within maxIter');
end

function [x, iter, hist] = newton_method(F, J, x0, tol)
    x = x0;
    hist = [];
    for iter = 1:100  % max 100 iterations
        f = F(x);
        Jmat = J(x);
        delta = -Jmat \ f;
        x_new = x + delta;
        hist(iter,:) = [iter, x_new'];
        if norm(delta, inf) < tol
            x = x_new;
            return;
        end
        x = x_new;
    end
    warning('Newton–Raphson did not converge');
end