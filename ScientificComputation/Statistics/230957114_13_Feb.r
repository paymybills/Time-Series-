
################ Practice Set 1 ################

# Missing Data + Relational + Logical Operators

#Q1
x <- c(12, NA, 25, 18, NA, 30, 10, NA)

# Display x
x

# Find which elements are NA
is.na(x)

# Count total missing values
sum(is.na(x))

# Remove missing values
na.omit(x)

# Replace missing values with mean of available values
x_mean <- x
x_mean[is.na(x_mean)] <- mean(x_mean, na.rm = TRUE)
x_mean

# Replace missing values with 0
x_zero <- x
x_zero[is.na(x_zero)] <- 0
x_zero


#Q2
v <- c(5, 12, 18, 3, 25, 8, 15)

# Find values greater than 10
v[v > 10]

# Find values less than 10
v[v < 10]

# Find values between 10 and 20 (inclusive)
v[v >= 10 & v <= 20]

# Find positions where values are greater than 10
which(v > 10)

# Find positions where values are even
which(v %% 2 == 0)



#Q3
x <- 10
y <- 20

# Evaluate: (x == 10) & (y == 20)
(x == 10) & (y == 20)
# Evaluate: (x == 5) & (y == 20)
(x == 5) & (y == 20)
# Evaluate: (x == 10) | (y == 5)
(x == 10) | (y == 5)
# Evaluate: !(x == 10)
!(x == 10)


#Q4
z <- c(2, 6, 9, 12, 15, 18, 21, 25)

# Find values greater than 10 AND divisible by 3
z[z > 10 & z %% 3 == 0]

# Find values less than 10 OR divisible by 5
z[z < 10 | z %% 5 == 0]

# Find values NOT divisible by 2
z[z %% 2 != 0]

# Cnt how many values are greater than 15
sum(z > 15)


#Q5
m <- c(85,90,76,65,55,25,45,66,80,76,70,90,82,35,45)

#function definition is as such G(m) ={ A if m>80, B if 60<=m<=80, C if 40<=m<60, D if m<40}
grade <- function(m) {
  if (m > 80) {
    return("A")
  } else if (m >= 60 && m <= 80) {
    return("B")
  } else if (m >= 40 && m < 60) {
    return("C")
  } else {
    return("D")
  }
}
# Apply the function to each element of m
grades <- sapply(m, grade)
grades


#Q6 Write the R code to calculate the values of given data(x) using the function f(x)= { 2x+1 :x<0, x^2 : 0<=x<=2, 3x : x>2}
f <- function(x) {
  if (x < 0) {
    return(2*x + 1)
  } else if (x >= 0 && x <= 2) {
    return(x^2)
  } else {
    return(3*x)
  }
}
# Apply the function to each element of x
x <- 1:10
f_values <- sapply(x, f)
f_values
#Now if I were to use a vectorized approach instead of sapply, I can do it like this:
f_vectorized <- function(x) {
  ifelse(x < 0, 2*x + 1, ifelse(x >= 0 & x <= 2, x^2, 3*x))
}
f_vectorized_values <- f_vectorized(x)
f_vectorized_values

#Q7 Write the R code to calculate the values of given data(x) using the function f(n)= { n^2: if n is even, n^3: if n is odd} for the sequence of numbers from 1 to 100.

f_n <- function(n) {
  if (n %% 2 == 0) {
    return(n^2)
  } else {
    return(n^3)
  }
}
# Apply the function to the sequence of numbers from 1 to 100
n_values <- 1:100
f_n_values <- sapply(n_values, f_n)
f_n_values


#Now if I were to use a vectorized approach instead of sapply, I can do it like this:
f_n_vectorized <- function(n) {
  ifelse(n %% 2 == 0, n^2, n^3)
}
f_n_vectorized_values <- f_n_vectorized(n_values)
f_n_vectorized_values
n 1:100