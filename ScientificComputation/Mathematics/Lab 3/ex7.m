F1 = @(x,y) sin(x) + y^2 - 1;
F2 = @(x,y) x^2 + y - 2;

% Jacobian components
J11 = @(x,y) cos(x);
J12 = @(x,y) 2*y;
J21 = @(x,y) 2*x;
J22 = @(x,y) 1;

x = 1; y = 1;   % initial guess
tol = 1e-6;
maxIter = 20;

fprintf('\nIter   x          y\n');
for iter = 1:maxIter
    f = [F1(x,y); F2(x,y)];
    J = [J11(x,y), J12(x,y);
         J21(x,y), J22(x,y)];
    delta = -J \ f;
    x_new = x + delta(1);
    y_new = y + delta(2);
    fprintf('%2d   %10.8f %10.8f\n', iter, x_new, y_new);
    if norm(delta, inf) < tol
        x = x_new; y = y_new;
        break;
    end
    x = x_new; y = y_new;
end
fprintf('\nSolution: x = %.8f, y = %.8f\n', x, y);

