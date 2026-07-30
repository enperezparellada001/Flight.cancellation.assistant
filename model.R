# model.R
# -----------------------------------------------------------------------------
# Skill: Use a Statistical Model
# Question: Which flights are more likely to be cancelled?
# Method: Logistic regression on the binary outcome 'cancelled', 70/30 split.
#
# TWO STATISTICAL POINTS TO KNOW AND DEFEND:
# 1. LEAKAGE: predictors are pre-departure only (set in build_model_frame()).
# 2. CLASS IMBALANCE: only ~1.5% of flights are cancelled. So a model can reach
#    ~98% ACCURACY by predicting "never cancelled" -- accuracy is misleading
#    here. AUC (threshold-free) and recall are the honest metrics. At a 0.5
#    cutoff, recall is near zero; the report discusses lowering the threshold.
# -----------------------------------------------------------------------------

library(dplyr)
library(pROC)

#' Fit and evaluate a logistic regression for cancellation
#'
#' @param model_frame Model-ready tibble from build_model_frame().
#' @param train_prop  Proportion used for training.
#' @param threshold   Probability cutoff for the positive class.
#' @param seed        Random seed for a reproducible split.
#' @return A list with the fitted model, test predictions, and metrics.
fit_cancellation_model <- function(model_frame, train_prop = 0.7,
                                   threshold = 0.5, seed = 123) {

  if (!"cancelled" %in% names(model_frame)) {
    stop("The model frame must contain a 'cancelled' outcome column.")
  }
  outcome_vals <- unique(model_frame$cancelled)
  if (!all(outcome_vals %in% c(0, 1)) || length(outcome_vals) < 2) {
    stop("Logistic regression requires a binary 0/1 outcome with both classes present.")
  }

  set.seed(seed)
  n <- nrow(model_frame)
  train_idx <- sample(seq_len(n), size = floor(train_prop * n))
  train <- model_frame[train_idx, ]
  test  <- droplevels(model_frame[-train_idx, ])

  model <- glm(cancelled ~ ., data = train, family = binomial())

  prob <- predict(model, newdata = test, type = "response")
  pred <- ifelse(prob >= threshold, 1, 0)

  tp <- sum(pred == 1 & test$cancelled == 1)
  tn <- sum(pred == 0 & test$cancelled == 0)
  fp <- sum(pred == 1 & test$cancelled == 0)
  fn <- sum(pred == 0 & test$cancelled == 1)

  safe <- function(num, den) if (den == 0) NA_real_ else num / den

  metrics <- tibble::tibble(
    accuracy    = (tp + tn) / (tp + tn + fp + fn),
    recall      = safe(tp, tp + fn),   # sensitivity: cancellations caught
    precision   = safe(tp, tp + fp),
    specificity = safe(tn, tn + fp),
    auc         = as.numeric(pROC::auc(test$cancelled, prob, quiet = TRUE)),
    threshold   = threshold
  )

  list(model = model, test = test, prob = prob, pred = pred, metrics = metrics)
}
