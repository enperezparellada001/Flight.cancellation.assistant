# trend_analysis.R
# -----------------------------------------------------------------------------
# Custom Skill 1 (visualization): Trend Analysis
# Question: How has flight volume or cancellation rate changed over the year?
# Method: Monthly aggregation + line chart.
# -----------------------------------------------------------------------------

library(dplyr)
library(ggplot2)
library(lubridate)

#' Summarize a monthly time trend and plot it
#'
#' @param data   Cleaned flights tibble (must contain flight_date).
#' @param metric Either "volume" (flight count) or "cancel_rate".
#' @return A list with a monthly summary tibble and a ggplot line chart.
trend_over_time <- function(data, metric = "cancel_rate") {

  if (!"flight_date" %in% names(data)) {
    stop("This skill requires a valid 'flight_date' variable. Run clean_flight_data() first.")
  }
  if (all(is.na(data$flight_date))) {
    stop("The 'flight_date' column exists but contains no valid dates.")
  }
  if (!metric %in% c("volume", "cancel_rate")) {
    stop("metric must be 'volume' or 'cancel_rate'.")
  }

  monthly <- data %>%
    filter(!is.na(flight_date)) %>%
    mutate(month = floor_date(flight_date, "month")) %>%
    group_by(month) %>%
    summarise(
      flights     = n(),
      cancel_rate = mean(cancelled, na.rm = TRUE),
      .groups = "drop"
    )

  y_var <- if (metric == "volume") "flights" else "cancel_rate"
  y_lab <- if (metric == "volume") "Flights per month" else "Cancellation rate"

  plot <- ggplot(monthly, aes(x = month, y = .data[[y_var]])) +
    geom_line(color = "#2c6e91", linewidth = 1) +
    geom_point(color = "#2c6e91") +
    labs(title = paste("Monthly", y_lab), x = "Month", y = y_lab) +
    theme_minimal(base_size = 12)

  list(monthly = monthly, plot = plot)
}
