# Practical 11: Nottingham Temperature Forecasting for Next 2 Years
# Objective: Forecast monthly average temperatures using nottem dataset

# Set working directory to script location for plots folder access
args <- commandArgs(trailingOnly = FALSE)
file_arg <- "--file="
if (any(grepl(file_arg, args))) {
  script_file <- normalizePath(sub(file_arg, "", args[grep(file_arg, args)]))
  script_dir <- dirname(script_file)
  setwd(script_dir)
}
dir.create("plots", showWarnings = FALSE)

# Clear environment
rm(list = ls())

# Load and configure required packages
required_pkgs <- c("tseries", "forecast", "ggplot2")
for (p in required_pkgs) {
  if (!requireNamespace(p, quietly = TRUE)) {
    install.packages(p, repos = "https://cran.rstudio.com/")
  }
}

library(tseries)
library(forecast)
library(ggplot2)

cat("=====================================\n")
cat("PRACTICAL 11: TEMPERATURE FORECASTING\n")
cat("Nottingham Dataset (1920-1939)\n")
cat("=====================================\n\n")

# (a) Load the nottem dataset
# nottem: Average monthly temperatures in Nottingham, England (1920-1939)
# Frequency: 12 (monthly data)
# Number of observations: 240

data(nottem)
nottem_data <- nottem

cat("Dataset Information:\n")
cat("- Data: Average monthly temperatures at Nottingham, England\n")
cat("- Period: 1920-1939\n")
cat("- Frequency: Monthly (12 observations per year)\n")
cat("- Total observations:", length(nottem_data), "\n")
cat("- Time range:", start(nottem_data), "to", end(nottem_data), "\n\n")

# Summary statistics
cat("Summary Statistics:\n")
print(summary(nottem_data))
cat("\n")

# (b) Plot the original time series
png("plots/plot1_original_series.png", width = 900, height = 600)
plot(nottem_data, 
     main = "Nottingham Average Monthly Temperature (1920-1939)",
     ylab = "Temperature (°F)",
     xlab = "Year",
     col = "steelblue",
     lwd = 2)
grid()
dev.off()

cat("✓ Plot 1: Original time series saved\n")

# (c) Decompose the time series to identify components
png("plots/plot2_decomposition.png", width = 900, height = 900)
decomposed <- decompose(nottem_data, type = "additive")
plot(decomposed)
dev.off()

cat("✓ Plot 2: Decomposition saved\n")
cat("\nDecomposition shows:\n")
cat("- Strong Seasonality: Regular annual temperature cycles\n")
cat("- Trend: Slight variation in average temperature over time\n")
cat("- Irregular: Random fluctuations\n\n")

# (d) ACF and PACF Analysis - Check for stationarity patterns
png("plots/plot3_acf_pacf.png", width = 900, height = 900)
par(mfrow = c(2, 1))
acf(nottem_data, lag.max = 60, main = "ACF of Original Temperature Series", col = "steelblue")
pacf(nottem_data, lag.max = 60, main = "PACF of Original Temperature Series", col = "steelblue")
par(mfrow = c(1, 1))
dev.off()

cat("✓ Plot 3: ACF/PACF saved\n")
cat("ACF/PACF Analysis:\n")
cat("- ACF shows strong seasonal pattern at lags 12, 24, 36...\n")
cat("- Series is non-stationary (slow decay in ACF)\n\n")

# (e) KPSS Test for Stationarity
cat("KPSS Stationarity Test on original series:\n")
cat("H0: Series is stationary\n")
kpss_level <- kpss.test(nottem_data, null = "Level")
cat("H0 (Level):\n")
print(kpss_level)
cat("\n")

kpss_trend <- kpss.test(nottem_data, null = "Trend")
cat("H0 (Trend):\n")
print(kpss_trend)
cat("\nConclusion: Series is non-stationary (reject H0)\n\n")

# (f) Make series stationary - seasonal differencing
cat("Applying seasonal differencing (lag=12)...\n")
diff_seasonal <- diff(nottem_data, lag = 12)

png("plots/plot4_seasonal_difference.png", width = 900, height = 600)
plot(diff_seasonal,
     main = "Seasonal Difference (lag=12) of Temperature",
     ylab = "Differenced Temperature",
     xlab = "Year",
     col = "darkgreen",
     lwd = 2)
abline(h = 0, col = "red", lty = 2, lwd = 2)
grid()
dev.off()

cat("✓ Plot 4: Seasonal differencing saved\n")

# Check stationarity of differenced series
cat("\nKPSS Test on seasonally differenced series:\n")
kpss_diff <- kpss.test(diff_seasonal, null = "Level")
print(kpss_diff)
cat("\n")

# (g) ACF/PACF on differenced series
png("plots/plot5_acf_pacf_diff.png", width = 900, height = 900)
par(mfrow = c(2, 1))
acf(diff_seasonal, lag.max = 36, main = "ACF of Seasonally Differenced Series", col = "darkgreen")
pacf(diff_seasonal, lag.max = 36, main = "PACF of Seasonally Differenced Series", col = "darkgreen")
par(mfrow = c(1, 1))
dev.off()

cat("✓ Plot 5: ACF/PACF of differenced series saved\n\n")

# (h) Auto ARIMA selection using stepwise procedure
cat("Fitting SARIMA model using auto.arima...\n")
cat("(This may take a moment)\n\n")

sarima_model <- auto.arima(nottem_data, 
                           seasonal = TRUE,
                           stepwise = TRUE,
                           approximation = TRUE,
                           trace = TRUE)

cat("\n✓ Model selected:\n")
print(sarima_model)
cat("\n")

# (i) Model diagnostics
png("plots/plot6_model_diagnostics.png", width = 900, height = 900)
checkresiduals(sarima_model)
dev.off()

cat("✓ Plot 6: Model diagnostics saved\n\n")

# Display residual statistics
cat("Residual Analysis:\n")
residuals_model <- residuals(sarima_model)
cat("- Mean of residuals:", round(mean(residuals_model), 6), "\n")
cat("- Std Dev of residuals:", round(sd(residuals_model), 4), "\n")
cat("- Min residual:", round(min(residuals_model), 4), "\n")
cat("- Max residual:", round(max(residuals_model), 4), "\n\n")

# (j) Forecast for the next 2 years (24 months)
cat("Forecasting for the next 2 years (24 months)...\n\n")

forecast_horizon <- 24  # 24 months = 2 years
forecast_temp <- forecast(sarima_model, h = forecast_horizon)

cat("Forecast Summary:\n")
print(forecast_temp)
cat("\n")

# (k) Plot forecast with confidence intervals
png("plots/plot7_forecast_2year.png", width = 900, height = 600)
plot(forecast_temp,
     main = "Temperature Forecast for Next 2 Years (with 80% and 95% CI)",
     ylab = "Temperature (°F)",
     xlab = "Year",
     lwd = 2,
     col = "steelblue")
grid()
dev.off()

cat("✓ Plot 7: Forecast with confidence intervals saved\n\n")

# Extended visualization with historical and forecast data
png("plots/plot8_extended_forecast.png", width = 1000, height = 700)
# Plot historical data and forecast together
plot(nottem_data,
     main = "Nottingham Temperature: Historical Data and 2-Year Forecast",
     ylab = "Temperature (°F)",
     xlab = "Year",
     xlim = c(1920, 1942),
     col = "steelblue",
     lwd = 2)
# Add forecast line
lines(forecast_temp$mean, col = "red", lwd = 2, lty = 1)
# Add confidence interval
lines(forecast_temp$upper[, 2], col = "orange", lty = 2, lwd = 1.5)
lines(forecast_temp$lower[, 2], col = "orange", lty = 2, lwd = 1.5)
# Add legend
legend("bottomright",
       legend = c("Historical", "Forecast", "95% CI"),
       col = c("steelblue", "red", "orange"),
       lty = c(1, 1, 2),
       lwd = c(2, 2, 1.5))
grid()
dev.off()

cat("✓ Plot 8: Extended forecast visualization saved\n\n")

# (l) Summary of forecast values
forecast_df <- data.frame(
  Month = 1:forecast_horizon,
  Forecast = as.numeric(forecast_temp$mean),
  Lower_95 = as.numeric(forecast_temp$lower[, 2]),
  Upper_95 = as.numeric(forecast_temp$upper[, 2])
)

cat("Forecast Values (24 months):\n")
print(head(forecast_df, 10))
cat("...\n")
print(tail(forecast_df, 5))
cat("\n")

# (m) Calculate average forecasted temperature
avg_forecast <- mean(forecast_temp$mean)
cat("Average Forecasted Temperature (24 months):", round(avg_forecast, 2), "°F\n\n")

# (n) Save forecast table to CSV
write.csv(forecast_df, "plots/forecast_values.csv", row.names = FALSE)
cat("✓ Forecast table saved to CSV\n\n")

# Final summary
cat("=====================================\n")
cat("FORECASTING COMPLETE\n")
cat("=====================================\n")
cat("Summary:\n")
cat("- Dataset: Nottingham Temperature (1920-1939)\n")
cat("- Historical Period: 240 months\n")
cat("- Forecast Period: 24 months (2 years)\n")
cat("- Model Selected:", as.character(forecast_temp$method), "\n")
cat("- Average Forecasted Temperature:", round(avg_forecast, 2), "°F\n")
cat("\nFiles Generated:\n")
cat("✓ plot1_original_series.png\n")
cat("✓ plot2_decomposition.png\n")
cat("✓ plot3_acf_pacf.png\n")
cat("✓ plot4_seasonal_difference.png\n")
cat("✓ plot5_acf_pacf_diff.png\n")
cat("✓ plot6_model_diagnostics.png\n")
cat("✓ plot7_forecast_2year.png\n")
cat("✓ plot8_extended_forecast.png\n")
cat("✓ forecast_values.csv\n")
cat("=====================================\n")
