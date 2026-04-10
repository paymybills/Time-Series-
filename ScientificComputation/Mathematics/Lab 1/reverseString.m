function out = reverseString(s)
% reverseString  Reverse characters of a string or character vector
%   out = reverseString(s) returns the reversed character vector.
%   Accepts MATLAB string scalar or char vector.

if isstring(s)
    s = char(s);
end
if ~ischar(s)
    error('Input must be a character vector or string scalar.');
end
out = s(end:-1:1);
end
