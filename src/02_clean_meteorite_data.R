#!/usr/bin/env Rscript
library(docopt)
library(tidyverse)

source("R/clean_meteorite_functions.R")

doc <- "
Usage:
  02_clean_meteorite_data.R --input=<input> --output=<output>

Options:
  --input=<input>     Input CSV from the download step.
  --output=<output>   Output path for the cleaned CSV.
"

args <- docopt(doc)

meteors <- read.csv(args$input)

validate_meteorite_columns(meteors)

meteors_clean <- meteors %>%
  filter_valid_meteorite_rows() %>%
  convert_meteorite_numeric() %>%
  filter_positive_mass() %>%
  add_meteorite_transforms() %>%
  filter_top_classes(n = 5)

dir.create(dirname(args$output), recursive = TRUE, showWarnings = FALSE)
write.csv((meteors_clean), args$output, row.names = FALSE)