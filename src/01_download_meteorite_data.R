#!/usr/bin/env Rscript
library(docopt)

doc <- "
Usage:
  01_download_meteorite_data.R --input=<input> --output=<output>

Options:
  --input=<input>     URL or local path to the source file.
  --output=<output>   File path where the downloaded/copied file will be saved.
"

args <- docopt(doc)

dir.create(dirname(args$output), recursive = TRUE, showWarnings = FALSE)

if (grepl("^https?://", args$input)) {
  download.file(args$input, args$output, method = "curl")
} else {
  file.copy(args$input, args$output, overwrite = TRUE)
}
