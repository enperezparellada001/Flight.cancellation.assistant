# cancellation_ranking.R
# -----------------------------------------------------------------------------
# Custom Skill 2 (decision support): Cancellation-Risk Ranking
# Question: Which flights/routes carry the highest cancellation risk, so
#           operations can plan proactively (crew, rebooking, communication)?
# Method: Score each flight with the fitted logistic model, then rank by risk.
# -----------------------------------------------------------------------------

library(dplyr)

#' Rank flights by predicted cancellation risk
#'
#' @param model   A fitted glm from fit_cancellation_model().
#' @param newdata Flights to score (same predictor columns as training).
#' @param top_n   Number of highest-risk flights to return.
#' @param dedupe  If TRUE, collapse identical predictor combinations.
#' @return A tibble ranked by descending cancellation probability.
rank_cancellation_risk <- function(model, newdata, top_n = 20, dedupe = TRUE) {

  if (is.null(model) || !inherits(model, "glm")) {
    stop("A fitted logistic model is required. Run fit_cancellation_model() first.")
  }
  needed <- all.vars(formula(model))[-1]
  missing_cols <- setdiff(needed, names(newdata))
  if (length(missing_cols) > 0) {
    stop("Cannot rank: newdata is missing required inputs: ",
         paste(missing_cols, collapse = ", "), ".")
  }

  scored <- newdata %>%
    mutate(cancel_probability = predict(model, newdata = ., type = "response"))

  # Collapse identical predictor profiles so the top list shows distinct risks.
  if (dedupe) {
    scored <- scored %>% distinct(across(all_of(needed)), .keep_all = TRUE)
  }

  scored %>%
    arrange(desc(cancel_probability)) %>%
    mutate(rank = row_number()) %>%
    head(top_n)
}
