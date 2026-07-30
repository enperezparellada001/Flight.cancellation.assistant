# Compare Two Groups

## Purpose
Tell the operations manager whether departure delays differ between weekend and
weekday flights, to inform scheduling and staffing.

## When to Use
Activate when the user asks whether a numeric outcome differs between two groups
(e.g. "Are weekend flights delayed more than weekday flights?").

## Required Inputs
- Cleaned flights dataset.
- A numeric outcome (default: `departure_delay`).
- A grouping variable with exactly two groups (default: `is_weekend`).

## Files Used
- `R/clean_data.R`
- `R/compare.R` -> `compare_groups()`

## Method
Welch's two-sample t-test (does not assume equal variances).

## Procedure
1. Load and clean the data.
2. Call `compare_groups(data, outcome, group)`.
3. Report each group's size and mean, the difference, the 95% CI, and the p-value.

## Validation
- Stop if either variable is missing.
- Stop if the outcome is not numeric.
- Stop if the grouping variable does not have exactly two groups.
- Stop if either group has fewer than 30 observations.

## Output
Per-group sizes and means, the mean difference, a 95% confidence interval, and a
p-value.

## Interpretation
State which group is delayed more, by roughly how many minutes, and how much
uncertainty surrounds that gap. Judge whether the difference is large enough to
matter operationally, not just whether it is statistically significant.

## Limitation
Observational: a difference does not prove the day type causes it. Cancelled
flights have no delay and are excluded from the comparison.
