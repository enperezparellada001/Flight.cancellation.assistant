# Data Access

This project uses the public **2015 Flight Delays and Cancellations** dataset
from the US Department of Transportation.

## Source
- Kaggle: "2015 Flight Delays and Cancellations" (publisher: usdot)
- Original: US DOT, Bureau of Transportation Statistics, On-Time Performance.

## How to get the data
1. Download `flights.csv` from the Kaggle dataset page.
2. Place it in this `data/` folder so the path is: `data/flights.csv`
3. (Optional) `airlines.csv` maps airline codes to names.

## Important: file size
`flights.csv` has ~5.8 million rows (~500 MB) and is NOT committed to Git.
`R/import_data.R` randomly samples 150,000 rows (fixed seed) so the project runs
and renders quickly and reproducibly. Adjust `sample_size` if you want more/less.

## About the data
- **One row = one scheduled US domestic flight in 2015.**
- Outcome variable: `cancelled` (1 = cancelled, 0 = operated).
- ~1.5% of flights are cancelled (an imbalanced outcome — see the Model skill).
- Columns describing what happened during a flight (delays, air time, arrival)
  are empty for cancelled flights and must NOT be used to predict cancellation.
