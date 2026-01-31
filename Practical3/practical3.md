# TSA Practical 3 Report

## Task
Decompose time-series data into trend, seasonal, and residual components and identify dominating components for:
(a) Nottem data
(b) AirPassengers data

## (a) Nottem Data

The `nottem` dataset contains average monthly temperatures at Nottingham, 1920–1939.

### Code
```r
data(nottem)
# Using Additive decomposition as temperature swings are roughly constant
nottem_decomp <- decompose(nottem, type = "additive")
plot(nottem_decomp)
```

### Decomposition Plot
![Nottem Decomposition](nottem_decomposition.png)

### Observations
*   **Trend:** The trend line is relatively flat, fluctuating slightly around the mean but showing no significant long-term increase or decrease.
*   **Seasonal:** There is a very distinct and regular seasonal pattern that repeats every year (12-month cycle).
*   **Random (Residual):** The residuals are small compared to the seasonal variation.
*   **Dominating Component:** **Seasonality** is clearly the dominating component.

---

## (b) AirPassengers Data

The `AirPassengers` dataset contains monthly airline passenger numbers from 1949-1960.

### Code
```r
data(AirPassengers)
# Using Multiplicative decomposition as the amplitude of seasonality increases with the trend
air_decomp <- decompose(AirPassengers, type = "multiplicative")
plot(air_decomp)
```

### Decomposition Plot
![AirPassengers Decomposition](airpassengers_decomposition.png)

### Observations
*   **Trend:** There is a strong, consistent upward trend over the entire period.
*   **Seasonal:** There is a clear seasonal pattern (peaks in summer months) which repeats annually.
*   **Random (Residual):** The Multiplicative model handles the increasing variance well, leaving relatively random residuals.
*   **Dominating Component:** Both **Trend** and **Seasonality** are dominating components. The series is driven by strong growth and strong seasonal travel patterns.
