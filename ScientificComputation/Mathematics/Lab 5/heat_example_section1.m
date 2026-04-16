clear
clc

% Worked example from heat-equation section
L = 1;
C = 1;
h = 0.25;
k = 0.02;

N = round(L / h);
M = 1;
x = 0:h:L;
lambda = k / (C * h^2);

u = zeros(N + 1, M + 1);
u(:, 1) = x .* (1 - x);
u(1, :) = 0;
u(end, :) = 0;

for j = 1:M
    for i = 2:N
        u(i, j + 1) = (1 - 2 * lambda) * u(i, j) + lambda * (u(i - 1, j) + u(i + 1, j));
    end
end

example_table = table((0:N).', x.', u(:, 1), u(:, 2), ...
    'VariableNames', {'i', 'x_i', 'u_i0', 'u_i1'});

disp('Heat example (Section 1):')
disp(['lambda = ', num2str(lambda)])
disp(example_table)

figure
plot(x, u(:, 1), 'o-', 'LineWidth', 1.5)
hold on
plot(x, u(:, 2), 's-', 'LineWidth', 1.5)
grid on
xlabel('x')
ylabel('u(x,t)')
title('Heat Example: t = 0 and t = 0.02')
legend('u(x,0)', 'u(x,0.02)', 'Location', 'northeast')
