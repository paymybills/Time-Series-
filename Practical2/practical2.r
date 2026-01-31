# Practical-2
rm(list=ls()) # Remove all previous variables

# (a) Write the R command to load the library in which the “Nottem” dataset is available.
# The 'nottem' dataset is part of the standard R 'datasets' package, which is loaded by default.
# However, explicit loading is good practice if it were in another package.
library(datasets)

# (b) Write the R command to load the “Nottem” dataset into the R working environment.
data(nottem)

# (c) Write the appropriate R command to view the description of the dataset and briefly explain the key characteristics of the data.
# To view the description in R, you would use: help(nottem) or ?nottem
# We will print the structure and summary statistics here to understand it.
print("Structure of the dataset:")
str(nottem)
print("Summary of the dataset:")
summary(nottem)

# Key characteristics (from help and structure):
# - It is a time series object of average monthly temperatures at Nottingham Castle.
# - The data covers the period 1920 to 1939.
# - Unit: Degrees Fahrenheit.

# (d) Explain the nature of the data in terms of its sampling frequency.
freq <- frequency(nottem)
print(paste("Frequency:", freq))
# Explanation:
# The frequency is 12, which indicates Monthly data (12 observations per year).
# Start(nottem) returns c(1920, 1) and End(nottem) returns c(1939, 12).

# (e) Plot the time series data and write your observations about the pattern of the data.
png("nottem_plot.png", width=800, height=600)
plot(nottem, 
     ylab = "Temperature (F)", 
     xlab = "Year",
     main = "Average Monthly Temperatures at Nottingham (1920-1939)")
dev.off()

# Observations:
# The dominating component is Seasonality. 
# There is a clear repeating pattern every year (12 months), corresponding to seasonal temperature changes (summer highs, winter lows).
# There is no obvious long-term Trend (the mean seems constant over the years).
print("Observation: The plot shows strong Seasonality with no obvious Trend.")
