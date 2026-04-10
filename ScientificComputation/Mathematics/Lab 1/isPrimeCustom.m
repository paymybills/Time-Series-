function tf = isPrimeCustom(n)
% isPrimeCustom  Check primality for integer input(s)
%   tf = isPrimeCustom(n) returns a logical array the same size as n.
%   Values that are non-integers or <2 return false.

origSize = size(n);
n_flat = n(:);
tf_flat = false(size(n_flat));
for idx = 1:numel(n_flat)
    ni = n_flat(idx);
    if ~isnumeric(ni) || ni~=floor(ni) || ni<2
        tf_flat(idx) = false;
        continue;
    end
    if ni == 2
        tf_flat(idx) = true;
        continue;
    end
    if mod(ni,2) == 0
        tf_flat(idx) = false;
        continue;
    end
    r = floor(sqrt(ni));
    isprimeflag = true;
    for d = 3:2:r
        if mod(ni,d) == 0
            isprimeflag = false;
            break;
        end
    end
    tf_flat(idx) = isprimeflag;
end

tf = reshape(tf_flat, origSize);
end
