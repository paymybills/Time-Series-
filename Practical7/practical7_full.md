# Practical 7: ARIMA Modeling and Goodness-of-Fit for Commercial Bank Real Estate Loans

## Objective
Analyze the monthly volume of commercial bank real estate loans (in billions of dollars) to:
- Import and visualize the data
- Identify dominant components (trend, seasonality, irregular)
- Test for stationarity using ACF/PACF and statistical tests
- Make the series stationary if required
- Select and fit a suitable ARIMA model
- Estimate parameters and check diagnostics

## Dataset
- **File**: `bank_case.txt`
- **Description**: Monthly volume of commercial bank real estate loans (billions of dollars)

## Analysis Steps and Code

### (a) Import Data
```r
# Read data
bank_data <- scan("bank_case.txt")
cat("First 10 values:\n")
print(head(bank_data, 10))
cat("Total number of observations:", length(bank_data), "\n")
```

### (b) Time Series Object
```r
# Create time series (monthly)
bank_ts <- ts(bank_data, frequency = 12, start = c(1, 1))
print(summary(bank_ts))
```

### (c) Plot & Decompose (identify dominant component)
```r
png("plots/plot1_timeseries.png", width = 800, height = 600)
plot(bank_ts, main = "Commercial Bank Real Estate Loans Over Time", xlab = "Time", ylab = "Loan Volume (Billions)", col = "blue", lwd = 2)
grid()
abline(lm(bank_ts ~ time(bank_ts)), col = "red", lty = 2)
dev.off()

decomposed <- decompose(bank_ts)
png("plots/plot2_decomposition.png", width = 800, height = 800)
plot(decomposed)
dev.off()
```

Files produced: `plots/plot1_timeseries.png`, `plots/plot2_decomposition.png`

### (d) ACF / PACF (stationarity check)
```r
png("plots/plot3_acf_pacf.png", width = 800, height = 800)
par(mfrow = c(2,1))
acf(bank_ts, lag.max = 36, main = "ACF of Bank Loan Data")
pacf(bank_ts, lag.max = 36, main = "PACF of Bank Loan Data")
par(mfrow = c(1,1))
dev.off()
```

File: `plots/plot3_acf_pacf.png`

### (e) ADF & KPSS tests
```r
if (!requireNamespace("tseries", quietly = TRUE)) {
  cat("Install the 'tseries' package to run ADF/KPSS tests.\n")
} else {
  library(tseries)
  adf_test <- adf.test(bank_ts, alternative = "stationary")
  print(adf_test)
  kpss_test <- kpss.test(bank_ts, null = "Trend")
  print(kpss_test)
}
```

### (f) Differencing to achieve stationarity
```r
bank_diff <- diff(bank_ts)
png("plots/plot4_first_difference.png", width = 800, height = 600)
plot(bank_diff, main = "First Difference of Bank Loan Data", col = "darkgreen")
abline(h = 0, col = "red", lty = 2)
dev.off()
if (requireNamespace("tseries", quietly = TRUE)) {
  print(adf.test(bank_diff, alternative = "stationary"))
  print(kpss.test(bank_diff, null = "Level"))
}
```

File: `plots/plot4_first_difference.png`

### (g) Model selection (ARIMA) and fitting
```r
if (requireNamespace("forecast", quietly = TRUE)) {
  library(forecast)
  best_model <- auto.arima(bank_ts)
} else {
  # fallback example model
  best_model <- arima(bank_ts, order = c(1,1,1))
}
print(best_model)
cat("AIC:", AIC(best_model), "\n")
```

### (h) Residual diagnostics & goodness-of-fit
```r
png("plots/plot5_residuals.png", width = 800, height = 800)
par(mfrow = c(2,2))
plot(residuals(best_model), main = "Residuals")
acf(residuals(best_model), main = "ACF of Residuals")
pacf(residuals(best_model), main = "PACF of Residuals")
qqnorm(residuals(best_model)); qqline(residuals(best_model), col = "red")
par(mfrow = c(1,1))
dev.off()
print(Box.test(residuals(best_model), lag = 20, type = "Ljung-Box"))
```

File: `plots/plot5_residuals.png`

## Results (summary)

| Component | Method | Result |
|---|---:|---|
| Dominant component | Decomposition & plot | Trend (upward) |
| Stationarity (visual) | ACF/PACF | Non-stationary (slow ACF decay) |
| Stationarity (stat) | ADF / KPSS | Non-stationary (see tests) |
| Differencing | diff() | First difference reduces trend; re-test for stationarity |
| Model selection | auto.arima / AIC | ARIMA chosen (see model summary) |
| Goodness of fit | Residuals, Ljung-Box | Acceptable if residuals uncorrelated |

## Generated files
- `plots/plot1_timeseries.png`
- `plots/plot2_decomposition.png`
- `plots/plot3_acf_pacf.png`
- `plots/plot4_first_difference.png`
- `plots/plot5_residuals.png`

## Notes
- Install missing packages if required:
  - `install.packages('tseries')`
  - `install.packages('forecast')`
- Run the script to regenerate plots:
```bash
Rscript Practical7/practical7.r
```

---

**Reference R Script:** See [practical7.r](Practical7/practical7.r)
**Data File:** [bank_case.txt](Practical7/bank_case.txt)
