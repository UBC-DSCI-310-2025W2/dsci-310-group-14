# Meteorite Landings Scripts

Run these in order:

1. `01_download_meteorite_data.R`
2. `02_clean_meteorite_data.R`
3. `03_eda_meteorite_data.R`
4. `04_model_meteorite_data.R`

Example:

```bash
Rscript 01_download_meteorite_data.R --input=https://data.nasa.gov/docs/legacy/meteorite_landings/Meteorite_Landings.csv --output=data/raw/meteorite_landings.csv
Rscript 02_clean_meteorite_data.R --input=data/raw/meteorite_landings.csv --output=data/processed/meteorite_landings_clean.csv
Rscript 03_eda_meteorite_data.R --input=data/processed/meteorite_landings_clean.csv --output=results/eda/meteorite_eda
Rscript 04_model_meteorite_data.R --input=data/processed/meteorite_landings_clean.csv --output=results/model/meteorite_model
```
