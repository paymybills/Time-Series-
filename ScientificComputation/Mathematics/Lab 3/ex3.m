A3 = [10, -1, 2, 0; -1, 11, -1, 3; 2, -1, 10, -1; 0, 3, -1, 8];
b3 = [6; 25; -11; 15];
x0 = zeros(4,1);
tol = 1e-4;
maxIter = 1000;
n3 = length(b3);
x = x0;
table = [];   % store iteration history
err = [];

fprintf('\nIteration   x1        x2        x3        x4\n');
for iter = 1:maxIter
    x_new = zeros(n3,1);
    for i = 1:n3
        % Compute sum_{j≠i} a_ij * x_j
        sum = 0;
        for j = 1:n3
            if j ~= i
                sum = sum + A3(i,j) * x(j);
            end
        end
        x_new(i) = (b3(i) - sum) / A3(i,i);
    end
    
    table(iter,:) = [iter, x_new'];
    err(iter) = norm(x_new - x, inf);
    
    if iter <= 10
        fprintf('%3d    %8.5f %8.5f %8.5f %8.5f\n', iter, x_new(1), x_new(2), x_new(3), x_new(4));
    end
    
    if err(iter) < tol
        fprintf('\nConverged after %d iterations\n', iter);
        x = x_new;
        break;
    end
    x = x_new;
end

fprintf('\nFinal solution:\n');
disp(x);

% Show full iteration table (first 10 rows already shown)
fprintf('\nIteration table (first 10 rows):\n');
disp(table(1:min(10,end), :));
