clear
clc

% Worked example from wave-equation section
L = 1;
T = 0.5;
c = 1;
h = 0.1;
k = 0.05;

N = round(L / h);
M = round(T / k);
x = 0:h:L;
t = 0:k:T;
lambda = c * k / h;

u = zeros(N + 1, M + 1);
u(:, 1) = sin(pi * x);
u(1, :) = 0;
u(end, :) = 0;

for i = 2:N
    u(i, 2) = u(i, 1) + 0.5 * lambda^2 * (u(i - 1, 1) - 2 * u(i, 1) + u(i + 1, 1));
end

for j = 2:M
    for i = 2:N
        u(i, j + 1) = 2 * u(i, j) - u(i, j - 1) + lambda^2 * (u(i - 1, j) - 2 * u(i, j) + u(i + 1, j));
    end
end

query_x = [0, 0.25, 0.5, 0.75, 1];
query_t = [0, 0.25, 0.5];

U_num = zeros(numel(query_x), numel(query_t));
for m = 1:numel(query_t)
    t_idx = round(query_t(m) / k) + 1;
    U_num(:, m) = interp1(x, u(:, t_idx), query_x, 'linear').';
end

U_exact = zeros(numel(query_x), numel(query_t));
for m = 1:numel(query_t)
    U_exact(:, m) = (sin(pi * query_x) * cos(pi * query_t(m))).';
end

num_table = array2table([query_x.', U_num], ...
    'VariableNames', {'x', 't0_num', 't025_num', 't05_num'});
exact_table = array2table([query_x.', U_exact], ...
    'VariableNames', {'x', 't0_exact', 't025_exact', 't05_exact'});

disp('Wave example (Section 2):')
disp(['lambda = ', num2str(lambda)])
disp('Numerical values at x = [0, 0.25, 0.5, 0.75, 1]')
disp(num_table)
disp('Exact values at x = [0, 0.25, 0.5, 0.75, 1]')
disp(exact_table)

figure
surf(t, x, u)
shading interp
xlabel('Time')
ylabel('Space')
zlabel('u(x,t)')
title('Wave Example Numerical Solution Surface')

figure
plot(query_x, U_num(:, 1), 'o-', 'LineWidth', 1.5)
hold on
plot(query_x, U_num(:, 2), 's-', 'LineWidth', 1.5)
plot(query_x, U_num(:, 3), '^-', 'LineWidth', 1.5)
grid on
xlabel('x')
ylabel('u(x,t)')
title('Wave Example Snapshots (Numerical)')
legend('t = 0', 't = 0.25', 't = 0.5', 'Location', 'northeast')