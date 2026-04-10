% solve_poisson_q2.m
% Solve Poisson problem on (0,1)x(0,1):
%   nabla^2 u = 81*x*y
% with Dirichlet boundary condition u=1 on the full boundary.

clear; clc;

% Grid setup
h = 0.1;                  % change if needed
x = 0:h:1;
y = 0:h:1;
N = numel(x) - 1;         % number of intervals in each direction
m = N - 1;                % number of interior points in each direction

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
        fval = -1*81 * xi * yj;

        A(k,k) = 4;
        b(k) = -h^2 * fval;

        % Left neighbor
        if i > 1
            A(k, idx(i-1,j)) = -1;
        else
            b(k) = b(k) + 1; % boundary value u(0,y)=1
        end

        % Right neighbor
        if i < m
            A(k, idx(i+1,j)) = -1;
        else
            b(k) = b(k) + 1; % boundary value u(1,y)=1
        end

        % Bottom neighbor
        if j > 1
            A(k, idx(i,j-1)) = -1;
        else
            b(k) = b(k) + 1; % boundary value u(x,0)=1
        end

        % Top neighbor
        if j < m
            A(k, idx(i,j+1)) = -1;
        else
            b(k) = b(k) + 1; % boundary value u(x,1)=1
        end
    end
end

uInterior = A \ b;

% Reconstruct full grid solution including boundaries
U = ones(N+1, N+1);
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
fprintf(fid, 'Boundary: u=1 on entire boundary\n');
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
title('Solution of \nabla^2 u = 81xy with u=1 on boundary');
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
