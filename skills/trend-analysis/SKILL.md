# Trend Analysis

## Purpose
Show the operations manager how flight volume or cancellation rate changed across
the year, to support seasonal planning.

## When to Use
Activate when the user asks about change over time, seasonality, or trends.

## Required Inputs
- Cleaned flights dataset with a valid `flight_date`.
- A metric: `volume` (flight counts) or `cancel_rate`.

## Files Used
- `R/clean_data.R`
- `R/trend_analysis.R` -> `trend_over_time()`

## Method
Aggregate flights to the month level and plot the chosen metric as a line chart.

## Procedure
1. Load and clean the data (which builds `flight_date`).
2. Call `trend_over_time(data, metric)`.
3. Return the monthly summary table and the trend line chart.

## Validation
- Stop if `flight_date` is missing.
- Stop if `flight_date` has no valid dates.
- Stop if the metric is not `volume` or `cancel_rate`.

## Output
A monthly summary table and a line chart of the trend.

## Interpretation
Point out months with elevated cancellation rates (e.g. winter storm season) so
the manager can prepare resources ahead of predictable peaks.

## Limitation
Describes the past for a single year; it is not a forecast and cannot separate
seasonality from one-off events.
