# Run the full analysis pipeline
all: results/model/meteorite_model_regression_lines.png \
     results/model/meteorite_model_pred_vs_actual.png \
     results/eda/meteorite_eda_eda_plot.png

# Download raw data
data/raw/meteorite_landings.csv: src/01_download_meteorite_data.R
	Rscript src/01_download_meteorite_data.R \
		--input=https://data.nasa.gov/docs/legacy/meteorite_landings/Meteorite_Landings.csv \
		--output=data/raw/meteorite_landings.csv

# Clean the raw data
data/processed/meteorite_landings_clean.csv: src/02_clean_meteorite_data.R data/raw/meteorite_landings.csv
	Rscript src/02_clean_meteorite_data.R \
		--input=data/raw/meteorite_landings.csv \
		--output=data/processed/meteorite_landings_clean.csv

# Run exploratory data analysis
results/eda/meteorite_eda_eda_plot.png: src/03_eda_meteorite_data.R \
                                        data/processed/meteorite_landings_clean.csv
	Rscript src/03_eda_meteorite_data.R \
		--input=data/processed/meteorite_landings_clean.csv \
		--output=results/eda/meteorite_eda

# Fit the model and generate plots
results/model/meteorite_model_regression_lines.png \
results/model/meteorite_model_pred_vs_actual.png: src/04_model_meteorite_data.R \
                                                  data/processed/meteorite_landings_clean.csv
	Rscript src/04_model_meteorite_data.R \
		--input=data/processed/meteorite_landings_clean.csv \
		--output=results/model/meteorite_model

# Delete all generated files
clean:
	rm -rf data/processed/ results/*

.PHONY: all clean
