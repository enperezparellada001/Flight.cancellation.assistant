# explore.R
# -----------------------------------------------------------------------------
# Skill: Explore Data
# Question: What does the distribution of a key numeric variable look like?
# (e.g. departure_delay in minutes, or route distance)
# Note: For departure_delay, NEGATIVE values are legitimate (early departures),
#       not errors -- the quality note reports the count for the analyst to judge.
# -----------------------------------------------------------------------------

library(dplyr)
library(ggplot2)

#' Explore the distribution of one numeric variable
#'
#' @param data Cleaned flights tibble.
#' @param var  Name of the numeric variable to explore (string).
#' @return A list with summary stats, a data-quality note, and a ggplot.
explore_variable <- function(data, var = "departure_delay") {

  # ---- Validation ----------------------------------------------------------
  if (!var %in% names(data)) {
    stop("Variable '", var, "' does not exist in the dataset.")
  }
  if (all(is.na(data[[var]]))) {
    stop("Variable '", var, "' is entirely missing (all NA).")
  }
  if (!is.numeric(data[[var]])) {
    stop(
      "Explore-with-a-histogram requires a NUMERIC variable. '", var,
      "' is ", class(data[[var]])[1],
      ". Use a bar chart for categorical variables such as 'airline' instead."
    )
  }

  x <- data[[var]]

  stats <- tibble::tibble(
    variable = var,
    n        = sum(!is.na(x)),
    missing  = sum(is.na(x)),
    mean     = mean(x, na.rm = TRUE),
    median   = median(x, na.rm = TRUE),
    sd       = sd(x, na.rm = TRUE),
    min      = min(x, na.rm = TRUE),
    q1       = quantile(x, 0.25, na.rm = TRUE),
    q3       = quantile(x, 0.75, na.rm = TRUE),
    max      = max(x, na.rm = TRUE)
  )

  quality_note <- paste0(
    "Missing values: ", stats$missing,
    " (these are largely cancelled flights, which have no recorded delay). ",
    "Negative values: ", sum(x < 0, na.rm = TRUE),
    " (for delay variables, negative means an EARLY departure -- not an error)."
  )

  # Trim the top 1% for a readable histogram (extreme delays flatten the axis).
  upper <- quantile(x, 0.99, na.rm = TRUE)
  plot <- ggplot(dplyr::filter(data, .data[[var]] <= upper),
                 aes(x = .data[[var]])) +
    geom_histogram(bins = 40, fill = "#2c6e91", color = "white") +
    labs(
      title = paste("Distribution of", var, "(bottom 99%)"),
      x = var, y = "Number of flights"
    ) +
    theme_minimal(base_size = 12)

  list(stats = stats, quality_note = quality_note, plot = plot)
}
