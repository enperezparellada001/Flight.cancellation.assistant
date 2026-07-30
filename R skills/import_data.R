# import_data.R
# -----------------------------------------------------------------------------
# Purpose: Read the DOT 2015 Flight Delays and Cancellations dataset.
# One row = one scheduled domestic US flight in 2015. ~5.8 million rows.
# Source: Kaggle "2015 Flight Delays and Cancellations" (US DOT / BTS).
#
# IMPORTANT: The full file is ~5.8M rows and will overwhelm a Quarto render.
# This script randomly samples a manageable slice (default 150,000 rows) with a
# fixed seed so the project is fast AND reproducible.
# -----------------------------------------------------------------------------

library(readr)
library(janitor)

#' Import (and sample) the flights dataset
#'
#' @param path        Path to flights.csv. Defaults to data/flights.csv
#' @param sample_size Number of rows to randomly sample (NULL = keep all).
#' @param seed        Random seed for a reproducible sample.
#' @return A tibble of flights with cleaned (snake_case) column names.
import_flight_data <- function(path = "data/flights.csv",
                               sample_size = 150000,
                               seed = 123) {

  # ---- Validation: file must exist -----------------------------------------
  if (!file.exists(path)) {
    stop(
      "Data file not found at '", path, "'. ",
      "Download 'flights.csv' from the Kaggle '2015 Flight Delays and ",
      "Cancellations' dataset and place it in the data/ folder. ",
      "See data/README.md for instructions."
    )
  }

  # ---- Read ----------------------------------------------------------------
  raw <- readr::read_csv(path, show_col_types = FALSE)
  raw <- janitor::clean_names(raw)

  # ---- Sample to keep the project fast and reproducible --------------------
  if (!is.null(sample_size) && nrow(raw) > sample_size) {
    set.seed(seed)
    raw <- raw[sample(seq_len(nrow(raw)), sample_size), ]
    message("Sampled ", sample_size, " of the full dataset for speed.")
  }

  message("Imported ", nrow(raw), " rows and ", ncol(raw), " columns.")
  raw
}

if (sys.nframe() == 0) {
  flights_raw <- import_flight_data()
  print(utils::head(flights_raw))
}
