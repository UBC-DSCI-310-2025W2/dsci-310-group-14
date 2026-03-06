set.seed(2026)
library(tidyverse)
library(rsample)
library(broom)

# Read in data
# getwd()
file_url <- "https://data.nasa.gov/docs/legacy/meteorite_landings/Meteorite_Landings.csv"
dest_file <- "data/raw/meteorite_landings.csv"
download.file(file_url, dest_file, method = "auto")
meteors <- read.csv("data/raw/meteorite_landings.csv")
# head(meteors)

# Clean data
meteors_clean <- meteors %>%
  drop_na(mass..g., year, reclat, reclong, fall, recclass) %>%
  mutate(
    mass = as.numeric(mass..g.),
    year = as.numeric(year),
    reclat = as.numeric(reclat),
    reclong = as.numeric(reclong)
  ) %>%
  drop_na(mass, year, reclat, reclong) %>%
  filter(mass > 0) %>%
  mutate(
    log_mass = log10(mass),
    fall = as.factor(fall),
    recclass = as.factor(recclass)
  )

top_classes <- meteors_clean %>%
  count(recclass, sort = TRUE) %>%
  slice_head(n = 5) %>%
  pull(recclass)

meteors_clean <- meteors_clean %>%
  filter(recclass %in% top_classes)


# Split data into training/testing
split_obj <- initial_split(meteors_clean, prop = 0.8)
train_data <- training(split_obj)
test_data  <- testing(split_obj)
head(test_data)

# Linear Regression model
model <- glm(
  log_mass ~ year * recclass + reclat + reclong + fall,
  data = train_data,
  family = gaussian()
)
tidy_model <- head(tidy(model))


# Predictions

year_seq <- seq(min(meteors_clean$year), max(meteors_clean$year), length.out = 100)

predictions <- predict(model, newdata = test_data)
prediction_grid <- expand.grid(
  year = year_seq,
  reclat = mean(meteors_clean$reclat),
  reclong = mean(meteors_clean$reclong),
  fall = levels(meteors_clean$fall)[1],   # fix one category
  recclass = top_classes
)

prediction_grid$pred_log_mass <- predict(model, newdata = prediction_grid)

# Plot
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
  ) +
  theme_minimal()

plot <- ggplot(test_data, aes(x = log_mass, y = predictions)) +
  geom_point(alpha = 0.4) +
  geom_abline(intercept = 0, slope = 1, color = "red") +
  labs(
    title = "Predicted vs Actual Log(Mass)",
    x = "Actual Log10(Mass)",
    y = "Predicted Log10(Mass)"
  ) +
  theme_minimal()

ggsave(
  filename = "output/regression_by_class.png",
  plot = plot_classes,
  width = 9,
  height = 6,
  dpi = 300
)

ggsave(
  filename = "output/predicted_vs_actual.png",
  plot = plot,
  width = 9,
  height = 6,
  dpi = 300
)