# Time Series Analysis - Practical 6
# Analysis of AirPassengers Data

cat("========== PRACTICAL 6: AirPassengers Analysis ==========\n\n")

# (a) Convert the data into a time series object
cat("========== (a) Load and Convert to Time Series Object ==========\n")

# Load the AirPassengers dataset (built-in R dataset)
data(AirPassengers)

# Display information about the dataset
cat("Dataset: AirPassengers\n")
cat("Description: Monthly totals of international airline passengers (1949-1960)\n")
cat("Number of observations:", length(AirPassengers), "\n")
cat("Start:", start(AirPassengers), "\n")
cat("End:", end(AirPassengers), "\n")
cat("Frequency:", frequency(AirPassengers), "\n\n")

# Display first and last few values
cat("First 12 values (Year 1949):\n")
print(head(AirPassengers, 12))

cat("\nLast 12 values (Year 1960):\n")
print(tail(AirPassengers, 12))

cat("\nSummary Statistics:\n")
print(summary(AirPassengers))
cat("\nStandard Deviation:", sd(AirPassengers), "\n\n")

# (b) Plot the data to identify the dominant component
cat("========== (b) Plot Data to Identify Dominant Component ==========\n")

png("plot1_airpassengers.png", width = 800, height = 600)
plot(AirPassengers, 
     main = "International Airline Passengers (1949-1960)",
     xlab = "Year",
     ylab = "Number of Passengers (thousands)",
     col = "blue",
     lwd = 2)
grid()
dev.off()

cat("Plot saved: plot1_airpassengers.png\n")
cat("Observation: Strong upward trend with increasing seasonal variation\n\n")

# (c) Decompose the data to observe the dominating components more clearly
cat("========== (c) Decompose Time Series ==========\n")

# Decompose using multiplicative model (variance increases with level)
decomposed <- decompose(AirPassengers, type = "multiplicative")

cat("Decomposing using MULTIPLICATIVE model (suitable for increasing variance)\n")
cat("Components:\n")
cat("- Trend: Long-term progression\n")
cat("- Seasonal: Repeating patterns\n")
cat("- Random: Irregular fluctuations\n\n")

png("plot2_decomposition.png", width = 800, height = 800)
plot(decomposed)
dev.off()

cat("Decomposition plot saved: plot2_decomposition.png\n\n")

# Also show additive decomposition for comparison
cat("For comparison, here's additive decomposition:\n")
decomposed_add <- decompose(AirPassengers, type = "additive")

png("plot3_decomposition_additive.png", width = 800, height = 800)
plot(decomposed_add)
dev.off()

cat("Additive decomposition saved: plot3_decomposition_additive.png\n")
cat("Note: Multiplicative is more appropriate for this data\n\n")

# Analyze the components
cat("Component Analysis:\n")
cat("- TREND: Strong upward growth in passengers over time\n")
cat("- SEASONAL: Clear yearly pattern (peaks in summer months)\n")
cat("- Both components are significant\n\n")

# (d) Check stationarity or non-stationarity using ACF/PACF plot
cat("========== (d) ACF/PACF Analysis for Stationarity ==========\n")

png("plot4_acf_pacf.png", width = 800, height = 800)
par(mfrow = c(2, 1))

# ACF plot
acf(AirPassengers, 
    main = "Autocorrelation Function (ACF) of AirPassengers",
    lag.max = 48,
    col = "blue",
    lwd = 2)

# PACF plot
pacf(AirPassengers, 
     main = "Partial Autocorrelation Function (PACF) of AirPassengers",
     lag.max = 48,
     col = "red",
     lwd = 2)

par(mfrow = c(1, 1))
dev.off()

cat("ACF/PACF plots saved: plot4_acf_pacf.png\n\n")

cat("ACF/PACF Interpretation:\n")
cat("- ACF shows slow decay → indicates NON-STATIONARITY\n")
cat("- Strong seasonal pattern visible in ACF (spikes at lags 12, 24, 36)\n")
cat("- Combination of trend and seasonality makes series non-stationary\n\n")

# (e) Check stationarity or non-stationarity using the Augmented Dickey-Fuller (ADF) test
cat("========== (e) Augmented Dickey-Fuller Test ==========\n")

# Load tseries package for ADF test
library(tseries, quietly = TRUE)

cat("Null Hypothesis (H0): Series has a unit root (non-stationary)\n")
cat("Alternative Hypothesis (H1): Series is stationary\n")
cat("Significance level: α = 0.05\n\n")

# Perform ADF test on original series
cat("--- ADF Test on Original Series ---\n")
adf_test <- adf.test(AirPassengers, alternative = "stationary")
print(adf_test)

cat("\n--- KPSS Test on Original Series ---\n")
kpss_test <- kpss.test(AirPassengers, null = "Trend")
print(kpss_test)

cat("\nInterpretation (ADF):\n")
if (adf_test$p.value < 0.05) {
    cat("ADF p-value =", adf_test$p.value, "< 0.05 → STATIONARY\n")
} else {
    cat("ADF p-value =", adf_test$p.value, ">= 0.05 → NON-STATIONARY\n")
}

cat("Interpretation (KPSS):\n")
if (kpss_test$p.value < 0.05) {
    cat("KPSS p-value =", kpss_test$p.value, "< 0.05 → NON-STATIONARY\n")
} else {
    cat("KPSS p-value =", kpss_test$p.value, ">= 0.05 → STATIONARY\n")
}

# Test on log-transformed data (to stabilize variance)
cat("\n========== Testing Log-Transformed Series ==========\n")
cat("Applying log transformation to stabilize variance...\n\n")

log_passengers <- log(AirPassengers)

png("plot5_log_transform.png", width = 800, height = 600)
plot(log_passengers,
     main = "Log-Transformed AirPassengers",
     xlab = "Year",
     ylab = "Log(Passengers)",
     col = "darkgreen",
     lwd = 2)
grid()
dev.off()

cat("Log-transformed plot saved: plot5_log_transform.png\n")

adf_log <- adf.test(log_passengers, alternative = "stationary")
cat("\n--- ADF Test on Log-Transformed Series ---\n")
print(adf_log)

kpss_log <- kpss.test(log_passengers, null = "Trend")
cat("\n--- KPSS Test on Log-Transformed Series ---\n")
print(kpss_log)

# Always perform differencing for demonstration purposes
cat("\n========== Performing Differencing for Analysis ==========\n")
cat("Applying first differencing to remove trend...\n\n")

diff_log_passengers <- diff(log_passengers)

png("plot6_diff_log.png", width = 800, height = 600)
plot(diff_log_passengers,
     main = "First Difference of Log(AirPassengers)",
     xlab = "Year",
     ylab = "Differenced Log(Passengers)",
     col = "purple",
     lwd = 2)
grid()
abline(h = 0, col = "red", lty = 2)
abline(h = mean(diff_log_passengers), col = "blue", lty = 2)
dev.off()

cat("Differenced log plot saved: plot6_diff_log.png\n")

adf_diff_log <- adf.test(diff_log_passengers, alternative = "stationary")
cat("\n--- ADF Test on Differenced Log Series ---\n")
print(adf_diff_log)

    kpss_diff_log <- kpss.test(diff_log_passengers, null = "Level")
    cat("\n--- KPSS Test on Differenced Log Series ---\n")
    print(kpss_diff_log)
    
    if (adf_diff_log$p.value < 0.05 || kpss_diff_log$p.value >= 0.05) {
        cat("\nThe differenced log series is STATIONARY\n")
        cat("Transformation: log(X) then difference → achieves stationarity\n")
    }

# Test seasonal difference as well
cat("\n========== Testing Seasonal Difference ==========\n")
cat("Applying seasonal differencing (lag=12) to remove seasonality...\n\n")

seasonal_diff <- diff(diff_log_passengers, lag = 12)

png("plot7_seasonal_diff.png", width = 800, height = 600)
plot(seasonal_diff,
     main = "Seasonal Difference of Differenced Log(AirPassengers)",
     xlab = "Year",
     ylab = "Seasonally Differenced Values",
     col = "orange",
     lwd = 2)
grid()
abline(h = 0, col = "red", lty = 2)
dev.off()

cat("Seasonal difference plot saved: plot7_seasonal_diff.png\n")

# Check if we have enough data for seasonal ADF test
if (length(seasonal_diff) > 13) {
    adf_seasonal <- adf.test(seasonal_diff, alternative = "stationary")
    cat("\n--- ADF Test on Seasonally Differenced Series ---\n")
    print(adf_seasonal)
    
    kpss_seasonal <- kpss.test(seasonal_diff, null = "Level")
    cat("\n--- KPSS Test on Seasonally Differenced Series ---\n")
    print(kpss_seasonal)
    
    if (adf_seasonal$p.value < 0.05 || kpss_seasonal$p.value >= 0.05) {
        cat("\nThe fully differenced series is STATIONARY\n")
        cat("Suggested ARIMA model: ARIMA(p,1,q)(P,1,Q)[12]\n")
        cat("This is a seasonal ARIMA model with:\n")
        cat("- Regular differencing (d=1)\n")
        cat("- Seasonal differencing (D=1) at lag 12\n")
    }
}


cat("\n========== Summary of Findings ==========\n")
cat("1. Data Type: Monthly time series (144 observations, 1949-1960)\n")
cat("2. Trend: Strong upward trend in passenger numbers\n")
cat("3. Seasonality: Clear yearly seasonal pattern\n")
cat("4. Variance: Increases with level (multiplicative model appropriate)\n")
cat("5. Stationarity: Original series is NON-STATIONARY\n")
cat("6. Transformations needed:\n")
cat("   - Log transformation (stabilize variance)\n")
cat("   - First differencing (remove trend)\n")
cat("   - Seasonal differencing (remove seasonality)\n")
cat("7. Model recommendation: SARIMA (Seasonal ARIMA)\n")

cat("\n========== Analysis Complete ==========\n")
