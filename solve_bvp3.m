% solve_bvp3.m
% Solve (x^3+1) y'' + (x^2-4x) y = 2 on [0,1]
% with boundary conditions y(0)=0, y(1)=4 using finite differences.
% Runs for h = 0.1, 0.2, 0.5 and writes results to diff_problem3.txt
% Also opens interactive MATLAB figure windows.

clear; clc;

hs = [0.1, 0.2, 0.5];
y0 = 0;
yN = 4;
xq = 0.5;

fid = fopen('diff_problem3.txt','w');
fprintf(fid, 'BVP: (x^3+1) y" + (x^2-4x) y = 2, y(0)=0, y(1)=4\n');
fprintf(fid, 'Finite-difference value at x=0.5 for each step size\n\n');
fprintf(fid, 'h\t y_h(0.5)\n');

all_x = cell(numel(hs),1);
all_y = cell(numel(hs),1);
all_labels = cell(numel(hs),1);

for k = 1:numel(hs)
    h = hs(k);
    N = round(1/h);
    x = linspace(0,1,N+1)';
    n = N-1;

    if n <= 0
        y = [y0; yN];
    else
        a = x.^3 + 1;
        a_half = (a(1:end-1) + a(2:end))/2;
        xi = x(2:end-1);
        c = xi.^2 - 4*xi;

        A = zeros(n,n);
        for i = 1:n
            ai_m_half = a_half(i);
            ai_p_half = a_half(i+1);

            A(i,i) = (ai_m_half + ai_p_half)/h^2 + c(i);
            if i > 1
                A(i,i-1) = -ai_m_half/h^2;
            end
            if i < n
                A(i,i+1) = -ai_p_half/h^2;
            end
        end

        b = 2*ones(n,1);
        b(1) = b(1) + a_half(1)/h^2 * y0;
        b(end) = b(end) + a_half(end)/h^2 * yN;

        y_in = A\b;
        y = [y0; y_in; yN];
    end

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
