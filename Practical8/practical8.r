# Practical 8: AirPassengers Time Series Analysis
# (f) Convert data into a time series object

# Ensure script runs relative to its own directory so plots/ is created there
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

# Load AirPassengers dataset
data(AirPassengers)
ap <- AirPassengers

cat("Dataset loaded. Observations:", length(ap), "\n")

# (g) Plot the data to identify the dominant component
png("plots/plot1_airpassengers.png", width = 900, height = 600)
plot(ap, main = "AirPassengers (1949-1960)", ylab = "Passengers (1000s)", xlab = "Year", col = "blue", lwd = 2)
grid()
dev.off()

# (h) Decompose the data to observe components
# Use multiplicative decomposition (variance increases with level)
png("plots/plot2_decomposition_multiplicative.png", width = 900, height = 900)
decomposed_mult <- decompose(ap, type = "multiplicative")
plot(decomposed_mult)
dev.off()

# Also show additive decomposition for comparison
png("plots/plot3_decomposition_additive.png", width = 900, height = 900)
decomposed_add <- decompose(ap, type = "additive")
plot(decomposed_add)
dev.off()

# (i) Check stationarity using ACF/PACF
png("plots/plot4_acf_pacf.png", width = 900, height = 900)
par(mfrow = c(2,1))
acf(ap, lag.max = 48, main = "ACF of AirPassengers")
pacf(ap, lag.max = 48, main = "PACF of AirPassengers")
par(mfrow = c(1,1))
dev.off()

# (j) KPSS test
cat("\nKPSS Test (null = Level):\n")
print(kpss.test(ap, null = "Level"))
cat("\nKPSS Test (null = Trend):\n")
print(kpss.test(ap, null = "Trend"))

# (k) If non-stationary, make stationary using appropriate operators
# Log transform to stabilize variance, then difference to remove trend and seasonality
log_ap <- log(ap)
png("plots/plot5_log_series.png", width = 900, height = 600)
plot(log_ap, main = "Log(AirPassengers)", ylab = "Log(Passengers)", xlab = "Year", col = "darkgreen", lwd = 2)
dev.off()

# First difference
diff1_log_ap <- diff(log_ap)
png("plots/plot6_diff1_log.png", width = 900, height = 600)
plot(diff1_log_ap, main = "First Difference of Log(AirPassengers)", ylab = "Differenced Log(Passengers)", xlab = "Year", col = "purple", lwd = 2)
abline(h = 0, col = "red", lty = 2)
dev.off()

# Seasonal difference (lag = 12) of log-differenced series
diff_seasonal <- diff(diff1_log_ap, lag = 12)
png("plots/plot7_seasonal_diff.png", width = 900, height = 600)
plot(diff_seasonal, main = "Seasonal Difference (s=12) of Differenced Log(AirPassengers)", ylab = "Seasonally Differenced", xlab = "Year", col = "orange", lwd = 2)
abline(h = 0, col = "red", lty = 2)
dev.off()

# Re-test stationarity on transformed series
cat("\nKPSS on differenced log series (level):\n")
print(kpss.test(diff1_log_ap, null = "Level"))
cat("\nKPSS on seasonally differenced series (level):\n")
print(kpss.test(diff_seasonal, null = "Level"))

# (l) Based on dominant components (trend + seasonality), select SARIMA
cat("\nSelecting SARIMA model using auto.arima on log-transformed data...\n")
# Use stepwise=FALSE for thorough search; enforce seasonal=TRUE
best_sarima <- auto.arima(log_ap, seasonal = TRUE, stepwise = FALSE, approximation = FALSE)
cat("Selected model:\n")
print(best_sarima)

# (m) Fit the data using selected model (already fitted by auto.arima)
# Forecast residual diagnostics and parameter estimates are available
cat("\nModel summary:\n")
print(summary(best_sarima))

# (n) Check goodness of fit
png("plots/plot8_residuals_diagnostics.png", width = 900, height = 900)
par(mfrow = c(2,2))
plot(residuals(best_sarima), main = "Residuals of SARIMA on log(AirPassengers)")
acf(residuals(best_sarima), main = "ACF of residuals")
pacf(residuals(best_sarima), main = "PACF of residuals")
qqnorm(residuals(best_sarima)); qqline(residuals(best_sarima), col = "red")
par(mfrow = c(1,1))
dev.off()

cat("\nLjung-Box test on residuals:\n")
print(Box.test(residuals(best_sarima), lag = 20, type = "Ljung-Box"))

# Save model object
saveRDS(best_sarima, file = "best_sarima_airpassengers.rds")

# List generated plot files
cat("\nGenerated plot files:\n")
plot_files <- list.files("plots", pattern = "plot.*\\.png$", full.names = FALSE)
if (length(plot_files) > 0) {
  print(file.path("plots", plot_files))
} else {
  cat("No PNG plot files found in plots/ directory.\n")
}

cat("\nPractical 8 analysis complete.\n")
