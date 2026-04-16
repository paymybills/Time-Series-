% solve_poisson_q2.m
% Solve Poisson problem on (0,1)x(0,1):
%   nabla^2 u = 81*x*y
% with Dirichlet boundary condition u=g(x,y) on the boundary.

clear; clc;

% Grid setup
h = 0.1;                  % change if needed
x = 0:h:1;
y = 0:h:1;
N = numel(x) - 1;         % number of intervals in each direction
m = N - 1;                % number of interior points in each direction

% Boundary function g(x,y):
% - for old condition u=1 on boundary, use: g = @(x,y) 1;
% - for requested condition u=x on boundary, use:
g = @(x,y) x;

if m < 1
    error('Step size h is too large. Need at least one interior point.');
end

% Build sparse system A*uint = b for interior unknowns
% Using 5-point stencil in form:
% 4*u(i,j) - u(i-1,j) - u(i+1,j) - u(i,j-1) - u(i,j+1) = -h^2*f(i,j)
% where f(x,y)=81*x*y.
nUnknowns = m * m;
A = spalloc(nUnknowns, nUnknowns, 5 * nUnknowns);
b = zeros(nUnknowns, 1);

idx = @(i,j) (j-1) * m + i; % interior index map, i,j = 1..m

for j = 1:m
    for i = 1:m
        k = idx(i,j);
        xi = x(i+1);
        yj = y(j+1);
        fval = -81 * xi * yj;

        A(k,k) = 4;
        b(k) = -h^2 * fval;

        % Left neighbor
        if i > 1
            A(k, idx(i-1,j)) = -1;
        else
            b(k) = b(k) + g(x(1), yj);
        end

        % Right neighbor
        if i < m
            A(k, idx(i+1,j)) = -1;
        else
            b(k) = b(k) + g(x(end), yj);
        end

        % Bottom neighbor
        if j > 1
            A(k, idx(i,j-1)) = -1;
        else
            b(k) = b(k) + g(xi, y(1));
        end

        % Top neighbor
        if j < m
            A(k, idx(i,j+1)) = -1;
        else
            b(k) = b(k) + g(xi, y(end));
        end
    end
end

uInterior = A \ b;

% Reconstruct full grid solution including boundaries
U = zeros(N+1, N+1);
for j = 1:N+1
    U(1, j) = g(x(1), y(j));
    U(end, j) = g(x(end), y(j));
end
for i = 1:N+1
    U(i, 1) = g(x(i), y(1));
    U(i, end) = g(x(i), y(end));
end
for j = 1:m
    for i = 1:m
        U(i+1, j+1) = uInterior(idx(i,j));
    end
end

% Report value near center
[~, ixMid] = min(abs(x - 0.5));
[~, iyMid] = min(abs(y - 0.5));
uMid = U(ixMid, iyMid);

fid = fopen('poisson_q2_results.txt', 'w');
fprintf(fid, 'Poisson equation: nabla^2 u = 81*x*y on [0,1]x[0,1]\n');
fprintf(fid, 'Boundary: u=g(x,y), currently g(x,y)=x on entire boundary\n');
fprintf(fid, 'h = %.4f\n', h);
fprintf(fid, 'u(%.3f, %.3f) = %.10f\n', x(ixMid), y(iyMid), uMid);
fclose(fid);

% Interactive plots (MATLAB figure windows)
[X, Y] = meshgrid(x, y);

fig1 = figure('Name', 'Poisson Solution Surface', 'NumberTitle', 'off');
surf(X, Y, U');
shading interp;
colorbar;
xlabel('x');
ylabel('y');
zlabel('u(x,y)');
title('Solution of \nabla^2 u = 81xy with u=x on boundary');
grid on;
rotate3d(fig1, 'on');
zoom(fig1, 'on');

fig2 = figure('Name', 'Poisson Solution Contours', 'NumberTitle', 'off');
contourf(X, Y, U', 20, 'LineColor', 'none');
colorbar;
xlabel('x');
ylabel('y');
title('Contour plot of u(x,y)');
axis equal tight;
zoom(fig2, 'on');
