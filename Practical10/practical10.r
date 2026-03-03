# Practical 10: AirPassengers Time Series Forecasting
# Objective: Forecast monthly passenger numbers for the next 12 months

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

# Step 1: Load the AirPassengers dataset
data(AirPassengers)
ap <- AirPassengers
cat("Dataset loaded. Observations:", length(ap), "\n")

# Step 2: Exploratory Data Analysis
png("plots/plot1_airpassengers.png", width = 900, height = 600)
plot(ap, main = "AirPassengers Time Series (1949-1960)", 
     ylab = "Passengers (1000s)", xlab = "Year", 
     col = "blue", lwd = 2)
grid()
dev.off()

# Seasonal Decomposition (Multiplicative since variance increases with level)
png("plots/plot2_decomposition.png", width = 900, height = 900)
ap_decomp <- decompose(ap, type = "multiplicative")
plot(ap_decomp)
dev.off()

# Step 3: Check Stationarity
cat("\nKPSS Test for Stationarity (null = Level):\n")
print(kpss.test(ap, null = "Level"))

png("plots/plot3_acf_pacf.png", width = 900, height = 900)
par(mfrow = c(2,1))
acf(ap, lag.max = 48, main = "ACF of AirPassengers")
pacf(ap, lag.max = 48, main = "PACF of AirPassengers")
par(mfrow = c(1,1))
dev.off()

# Step 4: Model Selection
# We'll use log transformation to stabilize variance then auto.arima for SARIMA
cat("\nSelecting SARIMA model on log-transformed data...\n")
log_ap <- log(ap)
best_model <- auto.arima(log_ap, seasonal = TRUE, stepwise = FALSE, approximation = FALSE)
cat("Selected model (on logged data):\n")
print(best_model)

# Step 5: Forecasting
# Forecast the next 12 months
cat("\nForecasting for the next 12 months...\n")
ap_forecast_log <- forecast(best_model, h = 12)

# Back-transform the forecast to original scale
# forecast() on an auto.arima log-fitted model automatically handles back-transformation 
# if the lambda=0 was used or it was manual log. However, to be explicit if using manual log:
# We'll re-fit with lambda=0 to have auto-backtransformation in the forecast object for plot clarity
final_model <- auto.arima(ap, lambda = 0, seasonal = TRUE, stepwise = FALSE, approximation = FALSE)
ap_forecast <- forecast(final_model, h = 12)

print(summary(ap_forecast))

# Plot the forecast
png("plots/plot4_forecast.png", width = 900, height = 600)
plot(ap_forecast, main = "12-Month Forecast of AirPassengers", 
     ylab = "Passengers (1000s)", xlab = "Year", 
     col = "blue", fcol = "red", lwd = 2)
grid()
dev.off()

# Step 6: Residual Diagnostics
png("plots/plot5_residuals.png", width = 900, height = 900)
checkresiduals(final_model)
dev.off()

cat("\nAnalysis complete. Results generated for Practical 10.\n")
