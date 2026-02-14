# Time Series Analysis - Practical 5
# Analysis of Commercial Bank Real Estate Loans Data

# (a) Import data into the R environment
# Read the data from text file
bank_data <- scan("bank_case.txt")

# Display the first few values
cat("First 10 values:\n")
print(head(bank_data, 10))

cat("\nTotal number of observations:", length(bank_data), "\n")

# (b) Convert the data into a time series object
# Assuming monthly data starting from a specific year
# You can adjust the start year as needed
bank_ts <- ts(bank_data, frequency = 12, start = c(1, 1))

# Display time series summary
cat("\nTime Series Object Summary:\n")
print(bank_ts)

# (c) Plot the data to identify the dominant component
# Main time series plot
png("plot1_timeseries.png", width = 800, height = 600)
plot(bank_ts, 
     main = "Commercial Bank Real Estate Loans Over Time",
     xlab = "Time",
     ylab = "Loan Volume (Billions of Dollars)",
     col = "blue",
     lwd = 2)
grid()

# Add a trend line to visualize the trend component
abline(lm(bank_ts ~ time(bank_ts)), col = "red", lwd = 2, lty = 2)
legend("topleft", 
       legend = c("Original Data", "Trend Line"), 
       col = c("blue", "red"), 
       lty = c(1, 2), 
       lwd = 2)
dev.off()

# Decompose the time series to see components
cat("\nDecomposing time series to identify components...\n")
decomposed <- decompose(bank_ts)
png("plot2_decomposition.png", width = 800, height = 800)
plot(decomposed)
dev.off()

# (d) Check stationarity or non-stationarity using ACF/PACF plot
# Set up plotting area for ACF and PACF
png("plot3_acf_pacf.png", width = 800, height = 800)
par(mfrow = c(2, 1))

# ACF plot
acf(bank_ts, 
    main = "Autocorrelation Function (ACF) of Bank Loan Data",
    lag.max = 36,
    col = "blue",
    lwd = 2)

# PACF plot
pacf(bank_ts, 
     main = "Partial Autocorrelation Function (PACF) of Bank Loan Data",
     lag.max = 36,
     col = "red",
     lwd = 2)

# Reset plotting area
par(mfrow = c(1, 1))
dev.off()

# Interpretation
cat("\nACF/PACF Interpretation:\n")
cat("- If ACF shows slow decay, the series is likely non-stationary\n")
cat("- If ACF cuts off quickly, the series might be stationary\n")
cat("- PACF helps identify the order of AR process\n\n")

# (e) Check stationarity or non-stationarity using the Augmented Dickey-Fuller (ADF) test
# Try to load the tseries package
tseries_available <- FALSE
tryCatch({
    # Try to load tseries from user library
    lib_path <- "~/R/x86_64-pc-linux-gnu-library/4.1"
    if (dir.exists(path.expand(lib_path))) {
        .libPaths(c(path.expand(lib_path), .libPaths()))
    }
    library(tseries)
    tseries_available <- TRUE
}, error = function(e) {
    cat("\n========== Package Installation Required ==========\n")
    cat("The 'tseries' package is not installed.\n")
    cat("To install it, run in R console:\n")
    cat("  install.packages('tseries')\n")
    cat("\nOr run this command in terminal:\n")
    cat("  sudo R -e \"install.packages('tseries', repos='https://cran.rstudio.com/')\"\n\n")
})

if (tseries_available) {
    cat("\n========== Augmented Dickey-Fuller Test ==========\n")
    cat("Null Hypothesis (H0): The series has a unit root (non-stationary)\n")
    cat("Alternative Hypothesis (H1): The series is stationary\n\n")
    
    # Perform ADF test
    adf_test <- adf.test(bank_ts, alternative = "stationary")
    print(adf_test)
    
    cat("\nInterpretation:\n")
    if (adf_test$p.value < 0.05) {
        cat("p-value =", adf_test$p.value, "< 0.05\n")
        cat("Result: REJECT the null hypothesis\n")
        cat("Conclusion: The series is STATIONARY\n")
    } else {
        cat("p-value =", adf_test$p.value, ">= 0.05\n")
        cat("Result: FAIL TO REJECT the null hypothesis\n")
        cat("Conclusion: The series is NON-STATIONARY\n")
        cat("Suggestion: Consider differencing the series to make it stationary\n")
    }

    cat("\n========== KPSS Test ==========\n")
    cat("Null Hypothesis (H0): The series is trend-stationary\n")
    cat("Alternative Hypothesis (H1): The series has a unit root (non-stationary)\n\n")
    
    # Perform KPSS test
    kpss_test <- kpss.test(bank_ts, null = "Trend")
    print(kpss_test)
    
    cat("\nInterpretation:\n")
    if (kpss_test$p.value < 0.05) {
        cat("p-value =", kpss_test$p.value, "< 0.05\n")
        cat("Result: REJECT the null hypothesis\n")
        cat("Conclusion: The series is NON-STATIONARY\n")
    } else {
        cat("p-value =", kpss_test$p.value, ">= 0.05\n")
        cat("Result: FAIL TO REJECT the null hypothesis\n")
        cat("Conclusion: The series is STATIONARY\n")
    }
    
    # Additional analysis: Test on first difference if original is non-stationary
    if (adf_test$p.value >= 0.05 || kpss_test$p.value < 0.05) {
        cat("\n========== Testing First Difference ==========\n")
        bank_diff <- diff(bank_ts)
        
        # Plot the differenced series
        png("plot4_first_difference.png", width = 800, height = 600)
        plot(bank_diff,
             main = "First Difference of Bank Loan Data",
             xlab = "Time",
             ylab = "Differenced Values",
             col = "darkgreen",
             lwd = 2)
        grid()
        abline(h = 0, col = "red", lty = 2)
        dev.off()
        
        # ADF test on differenced series
        adf_diff <- adf.test(bank_diff, alternative = "stationary")
        print(adf_diff)

        # KPSS test on differenced series
        kpss_diff <- kpss.test(bank_diff, null = "Level")
        print(kpss_diff)
        
        if (adf_diff$p.value < 0.05 || kpss_diff$p.value >= 0.05) {
            cat("\nThe first difference is STATIONARY\n")
            cat("\nThe original series is integrated of order 1, I(1)\n")
        }
    }
} else {
    cat("\n========== Alternative Stationarity Assessment ==========\n")
    cat("Based on visual inspection and ACF/PACF plots:\n\n")
    
    # Calculate some basic statistics
    cat("Mean of series:", mean(bank_ts), "\n")
    cat("Variance of series:", var(bank_ts), "\n")
    cat("Range: [", min(bank_ts), ",", max(bank_ts), "]\n\n")
    
    # Plot first difference for comparison
    cat("Plotting first difference for comparison...\n")
    bank_diff <- diff(bank_ts)
    
    png("plot4_first_difference.png", width = 800, height = 600)
    plot(bank_diff,
         main = "First Difference of Bank Loan Data",
         xlab = "Time",
         ylab = "Differenced Values",
         col = "darkgreen",
         lwd = 2)
    grid()
    abline(h = 0, col = "red", lty = 2)
    dev.off()
    
    cat("\nMean of differenced series:", mean(bank_diff), "\n")
    cat("Variance of differenced series:", var(bank_diff), "\n")
    
    cat("\nNote: The original series shows a clear upward trend,\n")
    cat("which strongly suggests NON-STATIONARITY.\n")
    cat("The ACF plot likely shows slow decay confirming this.\n")
    cat("\nFor formal ADF test, please install the 'tseries' package.\n")
}

cat("\n========== Analysis Complete ==========\n")
