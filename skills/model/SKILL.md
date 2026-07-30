# Use a Statistical Model

## Purpose
Estimate which flights are most likely to be cancelled, so operations can plan
crew, rebooking, and passenger communication proactively.

## When to Use
Activate when the user asks what factors are associated with cancellation, or
wants to estimate cancellation risk.

## Required Inputs
- Cleaned flights dataset.
- The model-ready frame from `build_model_frame()` (pre-departure predictors only).

## Files Used
- `R/clean_data.R` -> `build_model_frame()`
- `R/model.R` -> `fit_cancellation_model()`

## Method
Logistic regression on the binary outcome `cancelled`, with a 70/30 train/test
split. Metrics: accuracy, recall, precision, specificity, AUC.

## Procedure
1. Build the model frame (pre-departure predictors: airline, month, weekend,
   distance, departure hour).
2. Split into training and test sets with a fixed seed.
3. Fit on training data and evaluate on the held-out test set.

## Validation
- Stop if the outcome is not binary 0/1 with both classes present.
- Exclude leakage columns (delay, air time, arrival, cancellation_reason) before
  fitting -- they are only known once a flight operates.
- Drop unused factor levels in the test set to avoid unseen-category errors.

## Output
The fitted model, test predictions, and a metrics table.

## Interpretation
Because only ~1.5% of flights cancel, accuracy is misleading (predicting "never
cancel" scores ~98%). Lead with AUC and recall. Explain which factors raise risk
(e.g. certain months/airlines) and that the threshold can be lowered to catch
more at-risk flights.

## Limitation
Associations are not causal. The main real drivers (weather, mechanical faults)
are not in the data, so predictive power from scheduling features alone is limited.
