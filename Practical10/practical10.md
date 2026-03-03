# Practical 10: AirPassengers Time Series Forecasting

## Objective
The objective is to analyze the monthly international airline passengers dataset (`AirPassengers`) and forecast the passenger numbers for the next 12 months (the year 1961).

## Dataset
- **Source**: Standard R dataset `AirPassengers`.
- **Observations**: 144 (Monthly data from 1949 to 1960).
- **Units**: 1,000s of passengers.

## Methodology
1. **Visualization**: Plotted the original series to identify trend and seasonality.
2. **Decomposition**: Applied multiplicative decomposition because the seasonal variation increases as the trend increases.
3. **Stationarity Analysis**: Used KPSS test and ACF/PACF plots.
4. **Model Selection**: Used `auto.arima()` with a log transformation (`lambda=0`) to handle increasing variance.
5. **Validation**: Performed residual diagnostics (Ljung-Box test).
6. **Forecasting**: Projected values for the next 12 months.

## Code Snippet
The following R code was used to perform the analysis and generate the forecast:

```r
library(tseries)
library(forecast)

# Load data
data(AirPassengers)
ap <- AirPassengers

# Select best model with log transformation (lambda=0)
final_model <- auto.arima(ap, lambda = 0, seasonal = TRUE, stepwise = FALSE, approximation = FALSE)

# Forecast next 12 months
ap_forecast <- forecast(final_model, h = 12)
plot(ap_forecast)

# Diagnostics
checkresiduals(final_model)
```

## Results

### 1. Data Overview
The dataset shows a strong upward trend and clear seasonality.

![AirPassengers Original](plots/plot1_airpassengers.png)

### 2. Decomposition
The decomposition confirms both an upward trend and a strong seasonal component.

![Decomposition](plots/plot2_decomposition.png)

### 3. Model Identification
The KPSS test rejected stationarity ($p < 0.01$). The `auto.arima()` function selected a seasonal ARIMA model:
- **Model**: **SARIMA(0,1,1)(0,1,1)₁₂**
- **AIC**: -483.4
- **BIC**: -474.77

### 4. Forecast for 1961 (Next 12 Months)
The forecast continues both the growth trend and the seasonal patterns.

| Month | Point Forecast (1000s) | 95% Confidence Interval |
| :--- | :---: | :---: |
| Jan 1961 | **450.4** | [418.9, 484.3] |
| Feb 1961 | **425.7** | [391.2, 463.3] |
| Mar 1961 | **479.0** | [435.6, 526.8] |
| Apr 1961 | **492.4** | [443.5, 546.7] |
| May 1961 | **509.1** | [454.6, 570.0] |
| Jun 1961 | **583.3** | [516.8, 658.5] |
| Jul 1961 | **670.0** | [589.1, 762.1] |
| Aug 1961 | **667.1** | [582.3, 764.2] |
| Sep 1961 | **558.2** | [484.0, 643.8] |
| Oct 1961 | **497.2** | [428.3, 577.2] |
| Nov 1961 | **429.9** | [368.0, 502.1] |
| Dec 1961 | **477.2** | [406.2, 560.7] |

![Forecast Plot](plots/plot4_forecast.png)

### 5. Residual Diagnostics
The **Ljung-Box** test gave a p-value of **0.233** (> 0.05), indicating that the residuals are randomly distributed (white noise). This confirms the model is a good fit.

![Residuals](plots/plot5_residuals.png)

## Conclusion
The forecasting model **SARIMA(0,1,1)(0,1,1)₁₂** predicts that airline passenger numbers will continue to grow through 1961, maintaining the established seasonal peaks (peaking in July/August) and troughs (trough in November).
