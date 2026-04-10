% solve_bvp2.m
% Finite-difference solver for y''(x) + y(x) = x, y(0)=0, y(1)=1
% Writes comparison at x=0.5 for h = 0.1, 0.05, 0.2 into diff_problem2.txt
hs = [0.1, 0.05, 0.2];
fid = fopen('diff_problem2.txt','w');
fprintf(fid, 'h\t x=0.5 numeric\t exact\t error\n');
for h = hs
    N = round(1/h);
    x = 0:h:1;
    n = N-1; % number of interior points
    y0 = 0; yN = 1;
    p = 1; % coefficient in y'' + p y = r
    if n == 0
        y = [y0; yN];
    else
        e = ones(n,1);
        A = spdiags([-e (2/h^2 + p)*e -e], -1:1, n, n);
        xi = x(2:end-1)';
        b = xi; % r(x) = x
        b(1) = b(1) + y0/h^2;
        b(end) = b(end) + yN/h^2;
        y_in = A\b;
        y = [y0; y_in; yN];
    end
    idx = find(abs(x - 0.5) < 1e-12);
    if isempty(idx)
        [~, idx] = min(abs(x - 0.5));
    end
    ynum = y(idx);
    yex = 0.5; % analytical solution y(x)=x
    err = abs(ynum - yex);
    fprintf(fid, '%g\t %g\t %g\t %g\n', h, ynum, yex, err);
end
fclose(fid);
