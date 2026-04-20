clc

L = 1;
T = 0.5;
h = 0.25;
k = 0.01;
C = 1;

N = round(L / h);
M = round(T / k);
x = 0:h:L;
lambda = k / (C * h^2);

u = zeros(N + 1, M + 1);
u(:, 1) = sin(pi * x).';
u(1, :) = 0;
u(end, :) = 0;

for j = 1:M
    for i = 2:N
        u(i, j + 1) = (1 - 2 * lambda) * u(i, j) + lambda * (u(i - 1, j) + u(i + 1, j));
    end
end

exact = @(t) exp(-pi^2 * t) .* sin(pi * x).';
u_exact_1 = exact(k);
u_exact_2 = exact(2 * k);

result = table(x.', u(:, 2), u_exact_1, u(:, 3), u_exact_2, ...
    'VariableNames', {'x', 'Numerical_t1', 'Exact_t1', 'Numerical_t2', 'Exact_t2'});

disp('Heat equation: lambda =');
disp(lambda)
disp(result)

figure
plot(x, u(:, 2), 'o-', 'LineWidth', 1.5)
hold on
plot(x, u_exact_1, '--', 'LineWidth', 1.5)
plot(x, u(:, 3), 's-', 'LineWidth', 1.5)
plot(x, u_exact_2, ':', 'LineWidth', 1.5)
grid on
xlabel('x')
ylabel('u(x,t)')
title('Heat Equation: Numerical vs Exact Solution')
legend('Numerical t = 0.01', 'Exact t = 0.01', 'Numerical t = 0.02', 'Exact t = 0.02', 'Location', 'northeast')

figure
surf([0, k, 2 * k], x, u)
xlabel('Time')
ylabel('Space')
zlabel('Temperature')
title('Heat Equation Solution Surface')
shading interp
