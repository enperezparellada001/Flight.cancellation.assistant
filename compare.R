# compare.R
# -----------------------------------------------------------------------------
# Skill: Compare Two Groups
# Question: Do weekend flights have different departure delays than weekday ones?
# Method: Welch's two-sample t-test (does not assume equal variances).
# Note: Cancelled flights have no delay value, so they drop out automatically --
#       this compares OPERATED flights only.
# -----------------------------------------------------------------------------

library(dplyr)

#' Compare a numeric outcome between exactly two groups
#'
#' @param data    Cleaned flights tibble.
#' @param outcome Numeric outcome variable (string), e.g. "departure_delay".
#' @param group   Grouping variable (string), e.g. "is_weekend".
#' @param min_n   Minimum observations required per group.
#' @return A list with per-group results, difference, CI, p-value, and method.
compare_groups <- function(data, outcome = "departure_delay",
                           group = "is_weekend", min_n = 30) {

  if (!outcome %in% names(data)) stop("Outcome variable '", outcome, "' does not exist.")
  if (!group   %in% names(data)) stop("Grouping variable '", group, "' does not exist.")
  if (!is.numeric(data[[outcome]])) stop("The outcome '", outcome, "' must be numeric for a t-test.")

  d <- data %>% filter(!is.na(.data[[group]]), !is.na(.data[[outcome]]))
  groups <- sort(unique(d[[group]]))
  if (length(groups) != 2) {
    stop("The grouping variable '", group, "' must contain exactly two groups. Found ",
         length(groups), ": ", paste(groups, collapse = ", "), ".")
  }

  counts <- d %>% count(.data[[group]])
  if (any(counts$n < min_n)) {
    stop("Each group needs at least ", min_n, " observations. Sizes: ",
         paste(counts[[1]], counts$n, sep = "=", collapse = ", "), ".")
  }

  g1 <- d[[outcome]][d[[group]] == groups[1]]
  g2 <- d[[outcome]][d[[group]] == groups[2]]
  test <- t.test(g1, g2)  # Welch by default

  summary_tbl <- tibble::tibble(
    group = as.character(groups),
    n     = c(length(g1), length(g2)),
    mean  = c(mean(g1), mean(g2)),
    sd    = c(sd(g1), sd(g2))
  )

  list(
    outcome    = outcome,
    group      = group,
    summary    = summary_tbl,
    difference = unname(diff(rev(test$estimate))),  # group1 - group2
    ci_low     = test$conf.int[1],
    ci_high    = test$conf.int[2],
    p_value    = test$p.value,
    method     = "Welch two-sample t-test"
  )
}
