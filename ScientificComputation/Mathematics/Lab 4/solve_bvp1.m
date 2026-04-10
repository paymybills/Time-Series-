
hs = [0.1, 0.05, 0.2];
fid = fopen('diff_problem1.txt','w');
fprintf(fid, 'h\t x=0.5 numeric\t exact\t error\n');
for h = hs
    N = round(1/h);
    x = 0:h:1;
    n = N-1; % number of interior points
    if n == 0
        y = [0; 0];
    else
        e = ones(n,1);
        p = pi^2; % coefficient from y'' + p y = 0
        A = spdiags([-e (2/h^2 + p)*e -e], -1:1, n, n);
        b = zeros(n,1);
        y_in = A\b; 
        y = [0; y_in; 0];
    end
    idx = find(abs(x - 0.5) < 1e-12);
    if isempty(idx)
        [~, idx] = min(abs(x - 0.5));
    end
    ynum = y(idx);
    yex = sin(pi*0.5);
    err = abs(ynum - yex);
    fprintf(fid, '%g\t %g\t %g\t %g\n', h, ynum, yex, err);
end
fclose(fid);
