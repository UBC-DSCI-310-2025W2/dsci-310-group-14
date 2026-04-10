#!/usr/bin/env Rscript
# Model meteorite landing data using generalized linear regression
#
# This script:
# 1. Reads cleaned meteorite data
# 2. Splits data into training and testing sets  
# 3. Fits a GLM model using the training data
# 4. Generates predictions on a grid of years and meteorite classes
# 5. Creates visualizations of model results

library(docopt)
library(rsample)
library(ggplot2)
library(tidyverse)

source("R/meteorite_functions.R")

doc <- "
Usage:
  04_model_meteorite_data.R --input=<input> --output=<output>

Options:
  --input=<input>     Input CSV from the cleaning step.
  --output=<output>   Output prefix for model files.
"

args <- docopt(doc)

set.seed(42)

# Load data and ensure proper data types
meteors_clean <- read.csv(args$input)
meteors_clean$fall <- as.factor(meteors_clean$fall)
meteors_clean$recclass <- as.factor(meteors_clean$recclass)

# Generate a sequence of years for prediction grid
year_seq <- seq(min(meteors_clean$year), max(meteors_clean$year), length.out = 100)

# Filter to top 5 meteorite classes for model focus
top_classes <- meteors_clean %>%
  count(recclass, sort = TRUE) %>%
  slice_head(n = 5) %>%
  pull(recclass)

meteors_clean <- meteors_clean %>%
  filter(recclass %in% top_classes)

# Train-test split (80-20 split)
split_obj <- initial_split(meteors_clean, prop = 0.8)
train_data <- training(split_obj)
test_data  <- testing(split_obj)

# Fit the GLM model
model <- fit_meteorite_model(train_data)

# Generate predictions on test data
predictions <- predict(model, newdata = test_data)

# Create prediction grid for visualization
prediction_grid <- expand.grid(
  year = year_seq,
  reclat = mean(meteors_clean$reclat),
  reclong = mean(meteors_clean$reclong),
  fall = levels(meteors_clean$fall)[1],
  recclass = top_classes
)

prediction_grid$pred_log_mass <- predict(model, newdata = prediction_grid)

# Plot 1: Regression lines by meteorite class
options(repr.plot.width = 12, repr.plot.height = 5)

plot_classes <- ggplot(meteors_clean, aes(x = year, y = log_mass, color = recclass)) +
  geom_point(alpha = 0.3) +
  geom_line(
    data = prediction_grid,
    aes(x = year, y = pred_log_mass, color = recclass),
    linewidth = 1.2
  ) +
  labs(
    title = "Regression Lines by Meteorite Class",
    x = "Year",
    y = "Log10(Mass)",
    color = "Meteorite Class"
  )

dir.create(dirname(paste0(args$output, "_regression_lines.png")), recursive = TRUE, showWarnings = FALSE)
ggsave(paste0(args$output, "_regression_lines.png"), plot = plot_classes)

# Plot 2: Predicted vs Actual values
options(repr.plot.width = 12, repr.plot.height = 5)

plot_pred_vs_act <- ggplot(test_data, aes(x = log_mass, y = predictions)) +
  geom_point(aes(color = "Predictions"), alpha = 0.4) +
  geom_abline(intercept = 0, slope = 1, linewidth = 1) +
  scale_color_manual(
    name = "Legend",
    values = c("Predictions" = "black", "Perfect Fit" = "red")
  ) +
  labs(
    title = "Predicted vs Actual Log(Mass)",
    x = "Actual Log10(Mass)",
    y = "Predicted Log10(Mass)"
  )

ggsave(paste0(args$output, "_pred_vs_actual.png"), plot = plot_pred_vs_act, create.dir = TRUE)
