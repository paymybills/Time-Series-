clear
clc

L = 1;
T = 0.5;
h = 0.25;
k = 0.05;
c = 2;

N = round(L / h);
M = round(T / k);
x = 0:h:L;
t = 0:k:T;
lambda = c * k / h;

u = zeros(N + 1, M + 1);
u(:, 1) = x .* (1 - x);
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

disp('Wave equation: lambda =');
disp(lambda)
disp('Solution matrix rows = x, columns = t')
disp(array2table(u, 'VariableNames', compose('t_%0.2f', t), 'RowNames', compose('x_%0.2f', x)))

figure
surf(t, x, u)
shading interp
xlabel('Time')
ylabel('Space')
zlabel('Displacement')
title('Wave Equation Solution')

figure
plot(x, u(:, 1), 'o-', 'LineWidth', 1.5)
hold on
plot(x, u(:, round(M / 2) + 1), 's-', 'LineWidth', 1.5)
plot(x, u(:, end), '^-', 'LineWidth', 1.5)
grid on
xlabel('x')
ylabel('u(x,t)')
title('Wave Equation Snapshots')
legend('t = 0', sprintf('t = %.2f', t(round(M / 2) + 1)), sprintf('t = %.2f', t(end)), 'Location', 'northeast')