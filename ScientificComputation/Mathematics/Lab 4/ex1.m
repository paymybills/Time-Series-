% Define parameters
a = 0; b = 1; % Interval
h_vals = [0.1, 0.05, 0.2]; % Step sizes
x_exact = linspace(0, 1, 1000); % High resolution for plotting the exact line
y_exact = sin(pi * x_exact);     % Exact solution: y = sin(pi*x)

num_h = length(h_vals);
h_list = h_vals;
y_sol_list = zeros(num_h, length(x_exact));

fprintf('------------------------------------------\n');
fprintf('Definitive Comparison of Numerical Solutions\n');
fprintf('------------------------------------------\n');

% Loop through each step size
for i = 1:num_h
    h = h_vals(i);
    n = (b - a) / h + 1;
    x = a:h:b;
    
    % Allocate vector for y (including boundaries)
    y_num = zeros(1, n);
    
    % Apply Boundary Conditions
    y_num(1) = 0;  % y(0) = 0
    y_num(end) = 0; % y(1) = 0
    
    
    
    for j = 2:n-1
        
        y_num(j+1) = 2*y_num(j) - y_num(j-1) - (pi*h)^2 * y_num(j);
    end
    
    y_num(n) = 0; 
    
    y_sol_list(i, :) = y_num;
    
    idx_05 = find(x == 0.5, 1);
    if isempty(idx_05)
        idx_05 = round((0.5 - a)/h) + 1; 
y_sol_list(i,1:numel(y_num)) = y_num;
x_src = 1:numel(y_num);                 % original sample positions
x_target = linspace(1,numel(y_num),1000);
y_sol_list(i,:) = interp1(x_src, y_num, x_target, 'linear');
y_sol_list = zeros(N, 11);  % instead of zeros(N,1000)
y_sol_list(i,:) = y_num;    % now sizes match
assert(numel(y_num) == size(y_sol_list,2), ...
    'Length mismatch: y_num is %d but y_sol_list has %d columns', ...
    numel(y_num), size(y_sol_list,2));
    end
    
    exact_val = y_exact(find(x_exact == x(idx_05))); 
    num_val = y_num(idx_05);
    error_val = abs(exact_val - num_val);
    
    fprintf('\nStep Size h = %f\n', h);
    fprintf('X = 0.5\n');
    fprintf('Exact Value:      %.8f\n', exact_val);
    fprintf('Numerical Value:  %.8f\n', num_val);
    fprintf('Absolute Error:   %.4e\n', error_val);
end

% Plotting
figure('Color', 'w', 'Position', [100, 100, 800, 600]);
hold on; grid on; box on;

% Plot Exact Solution
plot(x_exact, y_exact, 'k-', 'LineWidth', 2, 'DisplayName', 'Exact Solution');

% Plot Numerical Solutions
colors = ['r', 'g', 'b'];
for i = 1:num_h
    plot(x, y_sol_list(i, :), [colors(i) '-o'], 'LineWidth', 1.5, 'MarkerSize', 4, 'MarkerFaceColor', 'none', 'DisplayName', sprintf('h = %s', num2str(h_vals(i), '%.2f')));
end

% Labels and Legend
xlabel('x');
ylabel('y(x)');
title('Comparison of Numerical Solutions vs Exact Solution for y'''' = -pi^2 y');
legend('show', 'Location', 'northeast');

hold off;
