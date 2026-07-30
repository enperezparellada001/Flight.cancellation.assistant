# Cancellation-Risk Ranking

## Purpose
Give the operations manager a prioritized list of the highest cancellation-risk
flight profiles, so contingency planning focuses where it matters most.

## When to Use
Activate when the user asks which flights or route profiles to watch or prepare
for first.

## Required Inputs
- A fitted logistic model from the Model skill.
- A set of flights to score (same predictor columns used in training).
- Optional: how many top-risk flights to return (`top_n`).

## Files Used
- `R/model.R` (to obtain the fitted model)
- `R/cancellation_ranking.R` -> `rank_cancellation_risk()`

## Method
Score each flight's cancellation probability with the fitted model, optionally
collapse identical profiles, then sort from highest to lowest risk.

## Procedure
1. Fit or load the cancellation model.
2. Call `rank_cancellation_risk(model, newdata, top_n)`.
3. Return the ranked table of highest-risk flight profiles.

## Validation
- Stop if no fitted logistic model is supplied.
- Stop if the flights are missing any predictor the model requires.

## Output
A ranked table of flight profiles with predicted cancellation probability and rank.

## Interpretation
The top of the list is where proactive planning is most warranted. Ranks are
relative priorities, not guarantees.

## Limitation
Only as good as the model, whose predictors exclude weather and mechanical causes.
A high rank is elevated risk, not a certain cancellation.
