#!/usr/bin/env Rscript
library(docopt)
library(here)

library(meteoriteutils)
doc <- "
Usage:
  01_download_meteorite_data.R --input=<input> --output=<output>

Options:
  --input=<input>     URL or local path to the source file.
  --output=<output>   File path where the downloaded/copied file will be saved.
"

args <- docopt(doc)

fetch_data(args$input, args$output)