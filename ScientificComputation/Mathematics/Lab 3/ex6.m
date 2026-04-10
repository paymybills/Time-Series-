F1 = @(x,y,z) x + y + z - 3;
F2 = @(x,y,z) x^2 + y^2 + z^2 - 5;
F3 = @(x,y,z) x - y + z - 1;

% Jacobian components
J11 = @(x,y,z) 1;   J12 = @(x,y,z) 1;   J13 = @(x,y,z) 1;
J21 = @(x,y,z) 2*x; J22 = @(x,y,z) 2*y; J23 = @(x,y,z) 2*z;
J31 = @(x,y,z) 1;   J32 = @(x,y,z) -1;  J33 = @(x,y,z) 1;

x = 1; y = 1; z = 1;   % initial guess
tol = 1e-6;
maxIter = 20;

fprintf('\nIter   x          y          z\n');
for iter = 1:maxIter
    f = [F1(x,y,z); F2(x,y,z); F3(x,y,z)];e
    J = [J11(x,y,z), J12(x,y,z), J13(x,y,z);
         J21(x,y,z), J22(x,y,z), J23(x,y,z);
         J31(x,y,z), J32(x,y,z), J33(x,y,z)];
    % Solve J * delta = -f
    % Note: At (1,1,1), J is singular. Using pinv to get a least-squares solution.
    if rcond(J) < 1e-12
        fprintf('\nWarning: Jacobian is nearly singular at iteration %d. Using pseudo-inverse.\n', iter);
        delta = -pinv(J) * f;
    else
        delta = -J \ f;
    end
    x_new = x + delta(1);
    y_new = y + delta(2);
    z_new = z + delta(3);
    fprintf('%2d   %10.8f %10.8f %10.8f\n', iter, x_new, y_new, z_new);
    if norm(delta, inf) < tol
        x = x_new; y = y_new; z = z_new;
        break;
    end
    x = x_new; y = y_new; z = z_new;
end
fprintf('\nSolution: x = %.8f, y = %.8f, z = %.8f\n', x, y, z);