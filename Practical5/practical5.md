# Practical 5: Time Series Stationarity Analysis

## Objective
Analyze the monthly volume of commercial bank real estate loans (in billions of dollars) to:
- Import and visualize the data
- Identify dominant components (trend, seasonality, etc.)
- Test for stationarity using ACF/PACF plots
- Perform Augmented Dickey-Fuller (ADF) test for stationarity

## Dataset
- **File**: `bank_case.txt`
- **Description**: Monthly volume of commercial bank real estate loans in billions of dollars
- **Number of observations**: 70 months

## Analysis Steps

### (a) Import Data
```r
bank_data <- scan("bank_case.txt")
```

### (b) Create Time Series Object
```r
bank_ts <- ts(bank_data, frequency = 12, start = c(1, 1))
```
- Frequency = 12 (monthly data)
- Creates a proper time series object for analysis

### (c) Identify Dominant Component

**Time series plot**: Visual inspection of overall pattern
- **Decomposition**: Separates trend, seasonal, and random components
- **Expected findings**: 
  - Strong upward trend visible in the data
  - Possible seasonal patterns

![Time Series Plot](plot1_timeseries.png)

**Figure 1**: Commercial Bank Real Estate Loans over time showing a clear upward trend from 46.5 to 87.6 billion dollars.

![Decomposition](plot2_decomposition.png)

**Figure 2**: Time series decomposition showing trend, seasonal, and random components. The **dominant component is the TREND** with consistent upward growth.

### (d) ACF/PACF Analysis

![ACF and PACF Plots](plot3_acf_pacf.png)

**Figure 3**: ACF and PACF plots for stationarity assessment.

**Autocorrelation Function (ACF)**:
- Shows correlation between observations at different lags
- Slow decay indicates non-stationarity
- Quick cutoff suggests stationarity

**Partial Autocorrelation Function (PACF)**:
- Shows direct correlation after removing influence of intermediate lags
- Helps identify AR order

**Interpretation Guidelines**:
- Non-stationary series: ACF decays slowly ← **This is what we observe**
- Stationary series: ACF cuts off quickly after a few lags

**Conclusion**: The ACF shows slow, gradual decay which is a strong indicator of **non-stationarity**.

### (e) Augmented Dickey-Fuller Test
**Hypotheses**:
- H₀: Series has a unit root (non-stationary)
- H₁: Series is stationary

**Decision Rule**:
- If p-value < 0.05: Reject H₀ → Series is stationary
- If p-value ≥ 0.05: Fail to reject H₀ → Series is non-stationary

**Remedial Actions** (if non-stationary):
- Apply first differencing
- Re-test the differenced series
- Continue until stationarity is achieved

![First Difference](plot4_first_difference.png)

**Figure 4**: First difference of the bank loan data showing fluctuations around a constant mean (the red line at zero). The differenced series appears more stable, suggesting that one differencing operation helps remove the trend.

## Expected Results

Based on the data pattern (increasing from 46.5 to 87.6):
1. **Dominant Component**: Strong upward trend ✓
2. **ACF**: Slow decay (indicating non-stationarity) ✓
3. **ADF Test**: Non-stationary confirmed
   - **Test Statistic**: -0.26816
   - **p-value**: 0.9894 >> 0.05
   - **Conclusion**: FAIL TO REJECT H₀ → Series is NON-STATIONARY
4. **First Difference ADF Test**:
   - **Test Statistic**: -1.7533
   - **p-value**: 0.6755
   - **Note**: First difference still shows some non-stationarity; may need second differencing or the series has strong dependencies

## Summary of Analysis

| Analysis Component | Method | Result |
|-------------------|--------|--------|
| Data Import | `scan()` | 70 observations loaded |
| Time Series Object | `ts()` | Monthly frequency (12) |
| Dominant Component | Visual + Decomposition | **TREND** (upward) |
| Stationarity (Visual) | ACF/PACF | Non-stationary (slow ACF decay) |
| Stationarity (Statistical) | ADF Test | Non-stationary (p = 0.9894) |
| First Difference | Differencing | Still shows some dependencies |

## Running the Analysis
```bash
cd "TSA/Practical 5"
Rscript practical5.r
```

Or in R console:
```r
source("practical5.r")
```

## Key Concepts

### Stationarity
A time series is stationary if:
- Mean is constant over time
- Variance is constant over time
- Covariance depends only on lag, not on time

### Why Stationarity Matters
- Many time series models (ARIMA) require stationary data
- Statistical properties are easier to model and forecast
- Non-stationary data can lead to spurious regression

### Differencing
- First difference: ∇Xₜ = Xₜ - Xₜ₋₁
- Removes trend component
- Often sufficient to achieve stationarity
