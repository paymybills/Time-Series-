# Practical-4
rm(list=ls()) # Remove all previous variables

# (a) Import the data as a time series object.
# Load data
df <- read.csv("us_pop_1970.csv")

# Create Time Series object
# Data spans 1970 to 1990, frequency is 1 (Annual)
pop_ts <- ts(df$Population, start = 1970, frequency = 1)
print("Time Series Object:")
print(pop_ts)

# (b) Identify the dominating component(s) in the data set.
# We plot it to see.
png("practical4_original.png")
plot(pop_ts, main = "US Population (1970-1990)", ylab = "Population", col = "blue", type = "o")
dev.off()
print("Dominating Component: Trend (Strong upward growth)")


# (c) Apply a square root transformation to the original data set.
# This is often used to stabilize variance if it increases with the level, 
# or to linearize a quadratic trend.
pop_sqrt <- sqrt(pop_ts)
png("practical4_sqrt.png")
plot(pop_sqrt, main = "Square Root Transformed Population", ylab = "Sqrt(Population)", col = "red", type = "o")
dev.off()


# (d) Estimate the linear trend present in the data set.
# We regress the population against time.
time_index <- time(pop_ts)
linear_model <- lm(pop_ts ~ time_index)

print("Linear Trend Model Summary:")
print(summary(linear_model))

# Extract slope and intercept
intercept <- coef(linear_model)[1]
slope <- coef(linear_model)[2]
print(paste("Estimated Linear Trend: Population =", round(intercept, 2), "+", round(slope, 2), "* Year"))


# (e) Remove the estimated linear trend from the data set.
# We subtracted the fitted values (trend) from the original series.
fitted_trend <- fitted(linear_model)
detrended_ts <- pop_ts - fitted_trend

png("practical4_detrended.png")
plot(detrended_ts, main = "Detrended Data (Original - Linear Trend)", ylab = "Residuals", col = "green", type = "o")
abline(h=0, col="gray", lty=2)
dev.off()

print("Detrended series created.")
