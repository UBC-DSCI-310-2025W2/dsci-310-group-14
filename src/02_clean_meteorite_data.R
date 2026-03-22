#!/usr/bin/env Rscript
library(docopt)
library(tidyverse)

doc <- "
Usage:
  02_clean_meteorite_data.R --input=<input> --output=<output>

Options:
  --input=<input>     Input CSV from the download step.
  --output=<output>   Output path for the cleaned CSV.
"

args <- docopt(doc)

meteors <- read.csv(args$input)

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

dir.create(dirname(args$output), recursive = TRUE, showWarnings = FALSE)
write.csv(meteors_clean, args$output, row.names = FALSE)
