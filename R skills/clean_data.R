# clean_data.R
# -----------------------------------------------------------------------------
# Purpose: Clean and prepare the flights data for analysis.
#
# CRITICAL MODELING NOTE (leakage):
# When a flight is CANCELLED, the columns describing what happened DURING the
# flight are empty/undefined: departure_delay, arrival_delay, air_time,
# elapsed_time, taxi_out, taxi_in, wheels_off, wheels_on, departure_time,
# arrival_time, diverted, and cancellation_reason. Using any of these to
# PREDICT cancellation is leakage -- they are only known once the flight has (or
# has not) operated. build_model_frame() therefore keeps ONLY variables known
# before departure (schedule, airline, route distance, timing).
# -----------------------------------------------------------------------------

library(dplyr)
library(lubridate)

#' Clean and prepare the flights data
#'
#' @param raw A tibble from import_flight_data().
#' @return A cleaned tibble with a real date and decision-relevant helpers.
clean_flight_data <- function(raw) {
  clean <- raw %>%
    mutate(
      # Coerce columns that may have been read as text into numbers
      scheduled_departure = as.numeric(scheduled_departure),
      distance = as.numeric(distance),
      departure_delay = as.numeric(departure_delay),
      # Build a real calendar date from year/month/day
      flight_date = make_date(year, month, day),

      # Weekend flag (exactly two groups) from the actual date
      is_weekend = factor(
        ifelse(wday(flight_date) %in% c(1, 7), "Weekend", "Weekday"),
        levels = c("Weekday", "Weekend")
      ),

      # Scheduled departure hour (0-23) from the HHMM integer
      dep_hour = scheduled_departure %/% 100,

      # Readable outcome label alongside the 0/1
      cancelled_label = factor(
        ifelse(cancelled == 1, "Cancelled", "Operated"),
        levels = c("Operated", "Cancelled")
      )
    )

  clean
}

#' Build a model-ready frame for cancellation prediction
#'
#' Keeps ONLY pre-departure predictors (no leakage). See the note at the top.
#'
#' @param clean A tibble from clean_flight_data().
#' @return A tibble ready for glm().
build_model_frame <- function(clean) {
  clean %>%
    transmute(
      cancelled  = cancelled,
      airline    = factor(airline),
      month      = factor(month),
      is_weekend = is_weekend,
      distance   = distance,
      dep_hour   = dep_hour
    ) %>%
    filter(!is.na(distance), !is.na(dep_hour), !is.na(cancelled))
}

if (sys.nframe() == 0) {
  source("R/import_data.R")
  raw <- import_flight_data()
  clean <- clean_flight_data(raw)
  mf <- build_model_frame(clean)
  message("Clean rows: ", nrow(clean), " | Model rows: ", nrow(mf))
  message("Cancellation rate: ", round(mean(clean$cancelled, na.rm = TRUE) * 100, 2), "%")
}
