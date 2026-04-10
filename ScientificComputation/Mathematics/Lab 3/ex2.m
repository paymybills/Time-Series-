A2 = [1e-5, 1, 1; 1, 1, 1; 1, 2, 3];
b2 = [2; 3; 6];
n2 = 3;


Aug2p = [A2, b2];
for k = 1:n2-1
    % Pivot: find row with largest |a_{ik}|
    [~, p] = max(abs(Aug2p(k:n2, k)));
    p = p + k - 1;
    if p ~= k
        Aug2p([k p], :) = Aug2p([p k], :);
        fprintf('Swap rows %d and %d:\n', k, p);
        disp(Aug2p);
    end
    for i = k+1:n2
        m = Aug2p(i,k) / Aug2p(k,k);
        Aug2p(i,:) = Aug2p(i,:) - m * Aug2p(k,:);
    end
end
x2_p = zeros(n2,1);
x2_p(n2) = Aug2p(n2,end) / Aug2p(n2,n2);
for i = n2-1:-1:1
    x2_p(i) = (Aug2p(i,end) - Aug2p(i,i+1:n2)*x2_p(i+1:n2)) / Aug2p(i,i);
end
fprintf('Solution:\n'); disp(x2_p);