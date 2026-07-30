# Explore Data

## Purpose
Help the airline operations manager understand the distribution of a key numeric
flight variable (for example, departure delay in minutes or route distance).

## When to Use
Activate when the user asks what a single numeric variable "looks like," its
typical value, spread, or whether it has unusual values.

## Required Inputs
- The cleaned flights dataset.
- One numeric variable name (default: `departure_delay`).

## Files Used
- `R/import_data.R`, `R/clean_data.R`
- `R/explore.R` -> `explore_variable()`

## Method
Descriptive statistics (mean, median, SD, five-number summary, missing count)
plus a histogram appropriate for a numeric variable.

## Procedure
1. Load and clean the data.
2. Call `explore_variable(data, var)`.
3. Return the statistics table, the data-quality note, and the histogram.

## Validation
- Stop if the variable does not exist.
- Stop if the variable is entirely missing (all NA).
- Stop if the variable is not numeric (histograms/means are wrong for categories
  such as `airline`; use a bar chart instead).

## Output
A summary-statistics table, a note on missing/negative values, and a histogram.

## Interpretation
Describe the typical delay, how spread out flights are, and note that most
flights leave close to on time while a few extreme delays stretch the average.

## Limitation
Describes one variable in isolation. Negative delays mean early departures, not
errors, and cancelled flights have no delay recorded.
