

fprintf('Demo: prime check (built-in vs custom)\n');
vals = [2 3 4 17 18];
fprintf('Values: %s\n', mat2str(vals));
builtin_tf = isprime(vals);
custom_tf = isPrimeCustom(vals);
fprintf('Built-in isprime:  %s\n', mat2str(builtin_tf));
fprintf('Custom isPrimeCustom: %s\n', mat2str(custom_tf));

fprintf('\nDemo: reverse number and string\n');
num = 8549;
revnum = reverseNumber(num);
fprintf('Original number: %d -> Reversed: %d\n', num, revnum);

str = 'Hello, world!';
revstr = reverseString(str);
fprintf('Original string: "%s" -> Reversed: "%s"\n', str, revstr);

fprintf('\nFactorial of 3: %d\n', factorial(3));
z = 3+4i;
fprintf('Complex abs of %s: %g\n', num2str(z), abs(z));
fprintf('Angle (deg): %g\n', rad2deg(angle(z)));