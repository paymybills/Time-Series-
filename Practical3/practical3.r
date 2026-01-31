# Practical-3
rm(list=ls()) # Remove all previous variables

# Consider the following datasets from the R library and write R code to decompose the
# time-series data into its trend, seasonal, and residual components. Furthermore, identify
# the dominating component(s) in the dataset:

# (a) Nottem data
print("--- Analysis for Nottem Data ---")
data(nottem)

# Decompose the time series
# Nottem temperature data is additive (seasonality amplitude doesn't change with trend)
nottem_decomp <- decompose(nottem, type = "additive")

# Plot the decomposition
png("nottem_decomposition.png", width=800, height=800)
plot(nottem_decomp)
dev.off()

# Analyze components
print("Nottem Dominating Component:")
print("The decomposition plot shows a very strong, consistent seasonal pattern.")
print("The trend component is relatively flat (stationary in mean).")
print("Therefore, Seasonality is the dominating component.")


# (b) AirPassengers data
print("--- Analysis for AirPassengers Data ---")
data(AirPassengers)

# Decompose the time series
# AirPassengers data shows increasing variance with the trend, so a Multiplicative model is more appropriate.
# However, for simple decomposition we can show the result. 
# We will use type="multiplicative" which is standard for this dataset.
air_decomp <- decompose(AirPassengers, type = "multiplicative")

# Plot the decomposition
png("airpassengers_decomposition.png", width=800, height=800)
plot(air_decomp)
dev.off()

# Analyze components
print("AirPassengers Dominating Component:")
print("The decomposition plot shows a clear upward Trend.")
print("It also shows strong Seasonality.")
print("Both Trend and Seasonality are dominating components in this dataset.")
