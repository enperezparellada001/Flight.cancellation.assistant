# data_quality_audit.R
# -----------------------------------------------------------------------------
# Custom Skill 3 (quantitative): Data Quality Audit
# Question: Are missing values, duplicates, or inconsistent values a problem?
# Method: Missing-value counts, duplicate detection, domain/consistency checks.
# -----------------------------------------------------------------------------

library(dplyr)

#' Audit the flights data for quality problems
#'
#' @param data Cleaned flights tibble.
#' @return A list with a missingness table and an issue-count table.
audit_data_quality <- function(data) {

  if (nrow(data) == 0) stop("The dataset is empty; nothing to audit.")

  missing_tbl <- tibble::tibble(
    variable    = names(data),
    n_missing   = sapply(data, function(col) sum(is.na(col))),
    pct_missing = round(sapply(data, function(col) mean(is.na(col))) * 100, 2)
  ) %>%
    filter(n_missing > 0) %>%
    arrange(desc(n_missing))

  # Domain / consistency checks specific to flight data.
  has <- function(col) col %in% names(data)

  issues <- tibble::tibble(
    check = c(
      "Duplicate rows",
      "Zero or negative distance",
      "Cancelled flag inconsistent with reason",
      "Departure hour out of range (0-23)"
    ),
    count = c(
      sum(duplicated(data)),
      if (has("distance")) sum(data$distance <= 0, na.rm = TRUE) else NA,
      # A cancellation_reason should appear only when cancelled == 1.
      if (has("cancellation_reason") && has("cancelled"))
        sum(!is.na(data$cancellation_reason) & data$cancelled == 0) else NA,
      if (has("dep_hour")) sum(data$dep_hour < 0 | data$dep_hour > 23, na.rm = TRUE) else NA
    )
  )

  list(missing = missing_tbl, issues = issues)
}
