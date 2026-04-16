% solve_bvp3.m
% Solve (x^3+1) y'' + (x^2-4x) y = 2 on [0,1]
% with boundary conditions y(0)=0, y(1)=4 using finite differences.
% Runs for h = 0.1, 0.2, 0.5 and writes results to diff_problem3.txt
% Also opens interactive MATLAB figure windows.
%
% This script uses a general finite-difference solver for equations of form:
%   y'' + p(x) y' + q(x) y = r(x)
% For this BVP, divide by (x^3+1):
%   y'' + 0*y' + ((x^2-4x)/(x^3+1))*y = 2/(x^3+1)

clear; clc;

% ---- User controls (safe to tweak) ----
% hs : mesh sizes to compare
% y0,yN : boundary values y(0), y(1)
% xq : point where y_h(xq) is sampled for comparison
hs = [0.1, 0.2, 0.5];
y0 = 0;
yN = 4;
xq = 0.5;
a = 0;
b = 1;

% Problem written in standard form y'' + p y' + q y = r
p = @(x) 0;
q = @(x) (x.^2 - 4*x) ./ (x.^3 + 1);
r = @(x) 2 ./ (x.^3 + 1);

% ---- Output file for quick numeric summary ----
fid = fopen('diff_problem3.txt','w');
fprintf(fid, 'BVP: (x^3+1) y" + (x^2-4x) y = 2, y(0)=0, y(1)=4\n');
fprintf(fid, 'Finite-difference value at x=0.5 for each step size\n\n');
fprintf(fid, 'h\t y_h(0.5)\n');

% Storage for plotting all h-curves after solving.
all_x = cell(numel(hs),1);
all_y = cell(numel(hs),1);
all_labels = cell(numel(hs),1);

for k = 1:numel(hs)
    h = hs(k);
    % Build grid on [0,1]: N intervals, N+1 nodes.
    N = round(1/h);
    [x, y] = fd_bvp(p, q, r, a, b, y0, yN, N);

    % Sample solution at xq for cross-h comparison.
    y_h_05 = interp1(x, y, xq, 'linear');
    fprintf(fid, '%.3g\t %.12f\n', h, y_h_05);

    all_x{k} = x;
    all_y{k} = y;
    all_labels{k} = sprintf('h = %.3g', h);
end

fprintf(fid, '\nGrid values used by each h:\n');
for k = 1:numel(hs)
    fprintf(fid, 'h = %.3g\t x = [', hs(k));
    fprintf(fid, '%g ', all_x{k});
    fprintf(fid, ']\t y = [' );
    fprintf(fid, '%g ', all_y{k});
    fprintf(fid, ']\n');
end
fclose(fid);

% ---- Figure 1: one panel per step size ----
fig_each = figure('Name','BVP3: Individual solutions by h','NumberTitle','off');
tiledlayout(2,2);
for k = 1:numel(hs)
    nexttile;
    plot(all_x{k}, all_y{k}, '-o', 'LineWidth', 1.4, 'MarkerSize', 6);
    grid on;
    xlabel('x');
    ylabel('y(x)');
    title(sprintf('Solution for %s', all_labels{k}));
end
zoom(fig_each, 'on');

% ---- Figure 2: all step sizes in one plot ----
fig_all = figure('Name','BVP3: Step-size comparison','NumberTitle','off');
hold on;
for k = 1:numel(hs)
    plot(all_x{k}, all_y{k}, '-o', 'LineWidth', 1.4, 'MarkerSize', 5, ...
        'DisplayName', all_labels{k});
end
hold off;
grid on;
xlabel('x');
ylabel('y(x)');
title('BVP solution comparison across step sizes (interactive)');
legend('Location','best');
zoom(fig_all, 'on');

% ---- General finite-difference BVP solver ----
% Solves: y'' + p(x) y' + q(x) y = r(x), x in [a,b]
% BCs: y(a)=alpha, y(b)=beta
% N: number of subintervals (N+1 grid points)
function [x, y] = fd_bvp(p, q, r, a, b, alpha, beta, N)
    h = (b-a)/N;
    x = linspace(a, b, N+1)';

    if N < 2
        y = [alpha; beta];
        return;
    end

    A = zeros(N-1, N-1);
    B = zeros(N-1, 1);

    for i = 1:N-1
        xi = a + i*h;
        A(i,i) = -2 + h^2 * q(xi);

        if i > 1
            A(i,i-1) = 1 - (h/2) * p(xi);
        end
        if i < N-1
            A(i,i+1) = 1 + (h/2) * p(xi);
        end

        B(i) = h^2 * r(xi);
    end

    B(1) = B(1) - (1 - (h/2) * p(a+h)) * alpha;
    B(end) = B(end) - (1 + (h/2) * p(b-h)) * beta;

    y_inner = A \ B;
    y = [alpha; y_inner; beta];
end
