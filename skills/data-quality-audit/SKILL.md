# Data Quality Audit

## Purpose
Warn the analyst and manager about missing values, duplicates, and inconsistent
values that could distort every other skill's results.

## When to Use
Activate when the user asks whether the data is trustworthy, or before relying on
any analysis for a decision.

## Required Inputs
- Cleaned flights dataset.

## Files Used
- `R/clean_data.R`
- `R/data_quality_audit.R` -> `audit_data_quality()`

## Method
Missing-value counts per column, duplicate-row detection, and domain/consistency
checks (non-positive distance, cancellation reason without a cancellation,
out-of-range departure hour).

## Procedure
1. Load and clean the data.
2. Call `audit_data_quality(data)`.
3. Return the missingness table and the issue-count table.

## Validation
- Stop if the dataset is empty.

## Output
A table of columns with missing values (count and percent) and a table of
data-quality issue counts.

## Interpretation
Explain that most missingness is structural -- cancelled flights legitimately
have no delay or arrival data -- and flag any genuine inconsistencies.

## Limitation
Detects only the specific problems it checks for. Passing the audit does not
guarantee the data is fully correct.
