# Practical 9: Commercial Bank Real Estate Loans Analysis
# Objective: Forecast the volume of commercial loans for the next 20 months

# Setup directories and paths
args <- commandArgs(trailingOnly = FALSE)
file_arg <- "--file="
if (any(grepl(file_arg, args))) {
  script_file <- normalizePath(sub(file_arg, "", args[grep(file_arg, args)]))
  script_dir <- dirname(script_file)
  setwd(script_dir)
}
dir.create("plots", showWarnings = FALSE)

# Ensure required packages are available
required_pkgs <- c("tseries", "forecast")
for (p in required_pkgs) {
  if (!requireNamespace(p, quietly = TRUE)) {
    install.packages(p, repos = "https://cran.rstudio.com/")
  }
}

library(tseries)
library(forecast)

# Step 1: Load the dataset
# Dataset contains monthly volume of commercial bank real estate loans
cat("Loading bank_case.txt...\n")
data_path <- "../Practical7/bank_case.txt"
bank_data <- read.table(data_path, header = FALSE)
bank_values <- bank_data$V1

# Step 2: Convert to time series object
# Assuming monthly data. The starting point is not specified, so we'll start at Year 1, Month 1.
bank_ts <- ts(bank_values, frequency = 12, start = c(1, 1))
cat("Dataset loaded. Observations:", length(bank_ts), "\n")

# Step 3: Exploratory Data Analysis
# Plot the original series
png("plots/plot1_bank_loans.png", width = 900, height = 600)
plot(bank_ts, main = "Commercial Bank Real Estate Loans", 
     ylab = "Volume (Billions)", xlab = "Time (Months)", 
     col = "blue", lwd = 2)
grid()
dev.off()

# Check for trend/seasonality components
png("plots/plot2_decomposition.png", width = 900, height = 900)
# Use additive decomposition as a first pass
bank_decomp <- decompose(bank_ts, type = "additive")
plot(bank_decomp)
dev.off()

# Step 4: Check Stationarity
cat("\nKPSS Test for Stationarity (null = Level):\n")
kpss_res <- kpss.test(bank_ts, null = "Level")
print(kpss_res)

# ACF and PACF plots
png("plots/plot3_acf_pacf.png", width = 900, height = 900)
par(mfrow = c(2,1))
acf(bank_ts, lag.max = 48, main = "ACF of Bank Loans")
pacf(bank_ts, lag.max = 48, main = "PACF of Bank Loans")
par(mfrow = c(1,1))
dev.off()

# Step 5: Model Selection and Fitting
# Use auto.arima to find the best (S)ARIMA model
cat("\nSelecting best model using auto.arima...\n")
best_model <- auto.arima(bank_ts, seasonal = TRUE, stepwise = FALSE, approximation = FALSE)
cat("Selected model:\n")
print(best_model)

# Step 6: Forecasting
# Forecast the next 20 months
cat("\nForecasting for the next 20 months...\n")
bank_forecast <- forecast(best_model, h = 20)
print(summary(bank_forecast))

# Plot the forecast
png("plots/plot4_forecast.png", width = 900, height = 600)
plot(bank_forecast, main = "20-Month Forecast of Commercial Bank Loans", 
     ylab = "Volume (Billions)", xlab = "Time (Months)", 
     col = "blue", fcol = "red", lwd = 2)
grid()
dev.off()

# Step 7: Residual Diagnostics
png("plots/plot5_residuals.png", width = 900, height = 900)
checkresiduals(best_model)
dev.off()

cat("\nAnalysis complete. Plots generated in the plots/ directory.\n")
