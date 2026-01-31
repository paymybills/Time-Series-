# TSA Practical 4 Report

## Task
For a given US Population dataset (1970-1990):
(a) Import as time series.
(b) Identify dominating component.
(c) Apply square root transformation.
(d) Estimate linear trend.
(e) Remove estimated linear trend.

### Analysis

#### (a) Time Series Import
The data was imported with `start=1970` and `frequency=1` (Annual).

```r
df <- read.csv("us_pop_1970.csv")
pop_ts <- ts(df$Population, start = 1970, frequency = 1)
```

#### (b) Dominating Component & (c) Transformation
The original data shows a very strong **Trend**.
Square root transformation was applied as requested: `sqrt(pop_ts)`.

Original Plot:
![Original](practical4_original.png)

#### (d) Estimate Linear Trend
A linear regression model `Population ~ Year` was fitted.

```r
linear_model <- lm(pop_ts ~ time(pop_ts))
```

**Results:**
*   **Intercept:** -2.398e+10
*   **Slope:** 1.215e+07 (The population increases by approximately 12.15 million per year on average).
*   **Formula:** $Population = -23,979,286,083.95 + 12,154,075.1 \times Year$
*   **R-squared:** 0.9219 (Indicates a strong linear fit, though the curve suggests an exponential or quadratic nature might fit better).

#### (e) Remove Linear Trend (Detrending)
The estimated linear trend (fitted values) was subtracted from the data.

```r
fitted_trend <- fitted(linear_model)
detrended_ts <- pop_ts - fitted_trend
```

Detrended Plot:
![Detrended](practical4_detrended.png)

The detrended plot shows a "U" shape, indicating that the original growth was non-linear (likely exponential), and a simple linear trend removal left a quadratic residual structure.
