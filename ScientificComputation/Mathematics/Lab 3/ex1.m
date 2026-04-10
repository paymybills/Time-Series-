A1 = [2, -1, 1; -3, -1, 2; -2, 1, 2];
b1 = [8; -11; -3];
n = length(b1);
Aug = [A1, b1];
disp('Initial augmented matrix:');
disp(Aug);

for k = 1:n-1
    for i = k+1:n
        m = Aug(i,k) / Aug(k,k);
        Aug(i,:) = Aug(i,:) - m * Aug(k,:);
    end
    fprintf('\nAfter elimination step k = %d:\n', k);
    disp(Aug);
end

x = zeros(n,1);
x(n) = Aug(n,end) / Aug(n,n);
for i = n-1:-1:1
    x(i) = (Aug(i,end) - Aug(i,i+1:n)*x(i+1:n)) / Aug(i,i);
end
fprintf('\nSolution:\n'); disp(x);