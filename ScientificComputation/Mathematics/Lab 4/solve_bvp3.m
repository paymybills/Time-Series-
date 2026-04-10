% solve_bvp3.m
% Solve (x^3+1) y'' + x^2 y - 4 x y = 2 on [0,1]
% with boundary conditions y(0)=0, y(1)=4 using finite differences.
% Runs for h = 0.1, 0.2, 0.5 and writes results to diff_problem3.txt

hs = [0.1, 0.2, 0.5];
y0 = 0; yN = 4;
fid = fopen('diff_problem3.txt','w');
fprintf(fid, 'h\t x_values\t y_values\n');
for h = hs
    N = round(1/h);
    x = linspace(0,1,N+1)'; % points 0..1, step h (N intervals -> N+1 pts)
    n = N-1; % number of interior points
    if n <= 0
        y = [y0; yN];
    else
        a = x.^3 + 1; % a(x)
        % a at half points
        a_half = (a(1:end-1) + a(2:end))/2; % length N
        % interior x
        xi = x(2:end-1);
        c = xi.^2 - 4*xi; % coefficient of y
        % build matrix A
        A = zeros(n,n);
        for i = 1:n
            ai_m_half = a_half(i);      % a_{i-1/2}
            ai_p_half = a_half(i+1);    % a_{i+1/2}
            main = (ai_m_half + ai_p_half)/h^2 + c(i);
            A(i,i) = main;
            if i > 1
                A(i,i-1) = -ai_m_half/h^2;
            end
            if i < n
                A(i,i+1) = -ai_p_half/h^2;
            end
        end
        b = 2*ones(n,1);
        % incorporate boundary values
        b(1) = b(1) + a_half(1)/h^2 * y0;
        b(end) = b(end) + a_half(end)/h^2 * yN;
        y_in = A\b;
        y = [y0; y_in; yN];
    end
    % write x and y vectors
    fprintf(fid, '%g\t', h);
    fprintf(fid, '[');
    fprintf(fid, '%g ', x);
    fprintf(fid, ']\t[');
    fprintf(fid, '%g ', y);
    fprintf(fid, ']\n');
end
fclose(fid);
