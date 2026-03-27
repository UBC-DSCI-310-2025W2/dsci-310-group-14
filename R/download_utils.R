# download_utils.R

#' Ensure a directory exists
#'
#' Creates the directory (and any required parent directories) at the given
#' path if it does not already exist. If the directory already exists, the
#' function does nothing and returns without error.
#'
#' @param path A non-empty character string specifying the directory path
#'
#' @return The `path` argument.
#'
#' @examples
#' tmp <- file.path(tempdir(), "new_subdir")
#' ensure_dir(tmp)
#' dir.exists(tmp) # TRUE
ensure_dir <- function(path) {
  if (!is.character(path) || length(path) != 1 || is.na(path) || nchar(path) == 0) {
    stop("`path` must be a single, non-empty character string.")
  }
  dir.create(path, recursive = TRUE, showWarnings = FALSE)
  return(path)
}


#' Download a file from a URL or copy from a local path
#'
#' If `input` begins with `"http://"` or `"https://"`, the file is
#'   downloaded using `download.file()`.
#'
#' @param input A non-empty character string. HTTP/HTTPS URL
#' @param output A non-empty character string specifying the local file path 
#' where the data will be saved.
#'
#' @return NULL. This function is called for its side effect of writing the
#' data file to disk.
#'
#' @examples
#' \dontrun{
#' ensure_dir("data/raw")
#' download_url_copy(
#'   input  = "https://data.nasa.gov/docs/legacy/meteorite_landings/Meteorite_Landings.csv",
#'   output = "data/raw/meteorite_landings.csv"
#' )
#' }
download_url_copy <- function(input, output) {

  if (!is.character(input) || length(input) != 1 || is.na(input) || nchar(input) == 0) {
    stop("`input` must be a single, non-empty character string.")
  }

  if (!is.character(output) || length(output) != 1 || is.na(output) || nchar(output) == 0) {
    stop("`output` must be a single, non-empty character string.")
  }

  if (file.exists(output)) {
    return(invisible(NULL))
  }

  if (grepl("^https?://", input)) {

    options(timeout = 300)

    download.file(
      url = input,
      destfile = output,
      method = "libcurl",
      mode = "wb",
      quiet = FALSE
    )

    if (!file.exists(output) || file.info(output)$size == 0) {
      stop("Downloaded file is empty.")
    }

    return(invisible(NULL))

  }

  if (!file.exists(input)) {
    stop(paste0("Source file does not exist: '", input, "'."))
  }
}



#' Fetch data from a URL or a local file path
#'
#' Retrieves a data file from either a remote HTTP/HTTPS URL or a local file
#' path and saves it to a specified output location. The output directory is
#' created automatically if it does not already exist.
#'
#'
#' @param input A non-empty character string. HTTP/HTTPS URL
#' @param output A non-empty character string specifying the local file path
#' where the data will be saved.
#'
#' @return The `output` path.
#'
#' @examples
#' \dontrun{
#' fetch_data(
#'   input  = "https://data.nasa.gov/docs/legacy/meteorite_landings/Meteorite_Landings.csv",
#'   output = "data/raw/meteorite_landings.csv"
#' )
#' }
fetch_data <- function(input, output) {
  if (!is.character(input) || length(input) != 1 || is.na(input) || nchar(input) == 0) {
    stop("`input` must be a single, non-empty character string.")
  }
  if (!is.character(output) || length(output) != 1 || is.na(output) || nchar(output) == 0) {
    stop("`output` must be a single, non-empty character string.")
  }
  ensure_dir(dirname(output))
  download_url_copy(input, output)
}