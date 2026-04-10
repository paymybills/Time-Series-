function out = reverseNumber(a)
% reverseNumber  Reverse digits of an integer, preserving sign
%   out = reverseNumber(a) returns the integer formed by reversing the
%   decimal digits of scalar integer a. Negative sign is preserved.

if ~isnumeric(a) || numel(a)~=1 || a~=floor(a)
    error('Input must be a scalar integer.');
end
signa = sign(a);
a = abs(a);
s = num2str(a);
srev = fliplr(s);
out = signa * str2double(srev);
end
