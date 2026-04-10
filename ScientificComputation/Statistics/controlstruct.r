#################### Practice Set 1 (For loop)

# Q1. Print the values of 3i+2 for i = 1 to 12.
cat("Practice Set 1 - Q1:\n")
for (i in 1:12) {
	cat(3*i + 2, " ")
}
cat("\n\n")

# Q2. Given the vector x = c(4, 9, 16, 25, 36). Print the square root of each element.
cat("Practice Set 1 - Q2:\n")
x <- c(4, 9, 16, 25, 36)
for (v in x) {
	cat(sqrt(v), " ")
}
cat("\n\n")

# Q3. Given a vector x = c(10, 25, 7, 18, 42, 5). Find the minimum element using for loop.
cat("Practice Set 1 - Q3:\n")
x <- c(10, 25, 7, 18, 42, 5)
min_val <- x[1]
for (v in x) {
	if (v < min_val) min_val <- v
}
cat("Minimum:", min_val, "\n\n")

# Q4. Print all numbers between 1 and 50 that are multiples of 4 but not multiples of 8.
cat("Practice Set 1 - Q4:\n")
for (n in 1:50) {
	if ((n %% 4) == 0 && (n %% 8) != 0) cat(n, " ")
}
cat("\n\n")

# Q5. Print the cubes of odd numbers from 1 to 15.
cat("Practice Set 1 - Q5:\n")
for (n in seq(1, 15, by = 2)) {
	cat(n^3, " ")
}
cat("\n\n")

# Q6. Find the factorial of 6.
cat("Practice Set 1 - Q6:\n")
fact6 <- 1
for (k in 1:6) fact6 <- fact6 * k
cat("6! =", fact6, "\n\n")

# Q7. Find the sum of all even numbers between 1 and 50.
cat("Practice Set 1 - Q7:\n")
sum_even <- 0
for (n in 1:50) if (n %% 2 == 0) sum_even <- sum_even + n
cat("Sum of evens 1..50 =", sum_even, "\n\n")

# Q8. Find the largest number among c(14, 27, 35, 9, 42, 18).
cat("Practice Set 1 - Q8:\n")
vals <- c(14, 27, 35, 9, 42, 18)
max_val <- vals[1]
for (v in vals) if (v > max_val) max_val <- v
cat("Maximum:", max_val, "\n\n")


#################### Practice Set 2 (while loop) ####################

# Q1. Print numbers from 1 to 10 using a while loop.
cat("Practice Set 2 - Q1:\n")
i <- 1
while (i <= 10) {
	cat(i, " ")
	i <- i + 1
}
cat("\n\n")

# Q2. Print even numbers less than 20.
cat("Practice Set 2 - Q2:\n")
i <- 2
while (i < 20) {
	cat(i, " ")
	i <- i + 2
}
cat("\n\n")

# Q3. Find the smallest n such that n^2 ≥ 150.
cat("Practice Set 2 - Q3:\n")
n <- 1
while (n^2 < 150) n <- n + 1
cat("Smallest n with n^2 >= 150:", n, "\n\n")

# Q4. Compute the sum of first 10 natural numbers.
cat("Practice Set 2 - Q4:\n")
sum10 <- 0
i <- 1
while (i <= 10) {
	sum10 <- sum10 + i
	i <- i + 1
}
cat("Sum 1..10 =", sum10, "\n\n")

# Q5. Print numbers starting from 3 and keep adding 4 each time until the number exceeds 50.
cat("Practice Set 2 - Q5:\n")
val <- 3
while (val <= 50) {
	cat(val, " ")
	val <- val + 4
}
cat("\n\n")

# Q6. Print cubes of numbers starting from 1 until the cube exceeds 300.
cat("Practice Set 2 - Q6:\n")
n <- 1
while (n^3 <= 300) {
	cat(n^3, " ")
	n <- n + 1
}
cat("\n\n")

# Q7. Given a number 8642, compute the sum of its digits using a while loop.
cat("Practice Set 2 - Q7:\n")
num <- 8642
sum_digits <- 0
tmp <- num
while (tmp > 0) {
	sum_digits <- sum_digits + (tmp %% 10)
	tmp <- tmp %/% 10
}
cat("Sum of digits of", num, "=", sum_digits, "\n\n")


#################### Practice Set 3 (repeat loop) ####################

# Q1. Print numbers from 1 to 8 using a repeat loop.
cat("Practice Set 3 - Q1:\n")
i <- 1
repeat {
	cat(i, " ")
	i <- i + 1
	if (i > 8) break
}
cat("\n\n")

# Q2. Print squares of numbers starting from 1 and stop when the square exceeds 50.
cat("Practice Set 3 - Q2:\n")
i <- 1
repeat {
	s <- i^2
	if (s > 50) break
	cat(s, " ")
	i <- i + 1
}
cat("\n\n")

# Q3. Keep adding natural numbers (starting from 1) until the sum exceeds 40.
cat("Practice Set 3 - Q3:\n")
sum_n <- 0
i <- 1
repeat {
	sum_n <- sum_n + i
	if (sum_n > 40) break
	i <- i + 1
}
cat("Final sum > 40:", sum_n, "(last added i=", i, ")\n\n")

# Q4. Print the sequence 3i-1 starting from i = 1 and stop when the value exceeds 50.
cat("Practice Set 3 - Q4:\n")
i <- 1
repeat {
	val <- 3*i - 1
	if (val > 50) break
	cat(val, " ")
	i <- i + 1
}
cat("\n\n")

# Q5. Compute the sum of consecutive even numbers starting from 2 and stop when the sum exceeds 150.
cat("Practice Set 3 - Q5:\n")
sum_evens <- 0
val <- 2
repeat {
	sum_evens <- sum_evens + val
	if (sum_evens > 150) break
	val <- val + 2
}
cat("Sum of evens final:", sum_evens, "(stopped after adding", val, ")\n\n")

# Q6. Compute the harmonic series 1 + 1/2 + 1/3 + ... and stop when the sum exceeds 5.
cat("Practice Set 3 - Q6:\n")
harm <- 0
i <- 1
repeat {
	harm <- harm + 1/i
	if (harm > 5) break
	i <- i + 1
}
cat("Harmonic sum > 5:", harm, "(last term 1/", i, ")\n\n")

# Q7. Compute the binomial expansion terms of (1+x)^n for x = 2 starting from n = 1 and stop when the value exceeds 300.
cat("Practice Set 3 - Q7:\n")
x <- 2
n <- 1
repeat {
	val <- (1 + x)^n
	if (val > 300) break
	cat("n=", n, ":", val, "\n")
	n <- n + 1
}
cat("\nDone.\n")

