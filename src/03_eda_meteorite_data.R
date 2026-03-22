#!/usr/bin/env Rscript

library(docopt)
library(ggplot2)
doc <- "
Usage:
  03_eda_meteorite_data.R --input=<input> --output=<output>

Options:
  --input=<input>     Input CSV from the cleaning step.
  --output=<output>   Output prefix for EDA files.
"

args <- docopt(doc)

meteors_clean <- read.csv(args$input)

# Simple exploratory plot
p1 <- ggplot(meteors_clean, aes(x = year, y = log_mass)) +
  geom_point(alpha = 0.3) +
  labs(
    title = "Year vs Log10(Mass)",
    x = "Year",
    y = "Log10(Mass)"
  )

ggsave(paste0(args$output, "_eda_plot.png"), plot = p1, create.dir = TRUE)
