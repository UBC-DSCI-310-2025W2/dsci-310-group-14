#' Validate required meteorite columns
#'
#' Checks that the input is a data frame and contains all required columns.
#'
#' @param df A data frame containing raw meteorite data.
#'
#' @return The input data frame invisibly if valid.
validate_meteorite_columns <- function(df) {
  if (!is.data.frame(df)) {
    stop("`df` must be a data frame.", call. = FALSE)
  }

  required_cols <- c("mass..g.", "year", "reclat", "reclong", "fall", "recclass")
  missing_cols <- setdiff(required_cols, names(df))

  if (length(missing_cols) > 0) {
    stop(
      paste("Missing required columns:", paste(missing_cols, collapse = ", ")),
      call. = FALSE
    )
  }

  invisible(df)
}

#' Filter valid meteorite rows
#'
#' Removes rows with missing required values.
#'
#' @param df A data frame containing raw meteorite data.
#'
#' @return A data frame with rows containing complete required values.
filter_valid_meteorite_rows <- function(df) {
  df %>%
    tidyr::drop_na(mass..g., year, reclat, reclong, fall, recclass)
}


#' Convert meteorite columns to numeric
#'
#' Converts selected columns to numeric and throws an error if conversion fails.
#'
#' @param df A data frame containing meteorite data.
#'
#' @return A data frame with numeric `mass`, `year`, `reclat`, and `reclong` columns.
convert_meteorite_numeric <- function(df) {
  mass_num <- suppressWarnings(as.numeric(df$mass..g.))
  year_num <- suppressWarnings(as.numeric(df$year))
  reclat_num <- suppressWarnings(as.numeric(df$reclat))
  reclong_num <- suppressWarnings(as.numeric(df$reclong))

  if (any(is.na(mass_num) & !is.na(df$mass..g.))) {
    stop("`mass..g.` contains values that cannot be converted to numeric.", call. = FALSE)
  }

  if (any(is.na(year_num) & !is.na(df$year))) {
    stop("`year` contains values that cannot be converted to numeric.", call. = FALSE)
  }

  if (any(is.na(reclat_num) & !is.na(df$reclat))) {
    stop("`reclat` contains values that cannot be converted to numeric.", call. = FALSE)
  }

  if (any(is.na(reclong_num) & !is.na(df$reclong))) {
    stop("`reclong` contains values that cannot be converted to numeric.", call. = FALSE)
  }

  df %>%
    dplyr::mutate(
      mass = mass_num,
      year = year_num,
      reclat = reclat_num,
      reclong = reclong_num
    )
}

#' Filter meteorites with positive mass
#'
#' Keeps only rows with positive mass values.
#'
#' @param df A data frame containing a numeric `mass` column.
#'
#' @return A data frame containing only rows with `mass > 0`.
filter_positive_mass <- function(df) {
  df %>%
    dplyr::filter(mass > 0)
}


#' Convert meteorite columns to numeric
#'
#' Converts selected columns to numeric and throws an error if conversion fails.
#'
#' @param df A data frame containing meteorite data.
#'
#' @return A data frame with numeric `mass`, `year`, `reclat`, and `reclong` columns.
convert_meteorite_numeric <- function(df) {
  mass_num <- suppressWarnings(as.numeric(df$mass..g.))
  year_num <- suppressWarnings(as.numeric(df$year))
  reclat_num <- suppressWarnings(as.numeric(df$reclat))
  reclong_num <- suppressWarnings(as.numeric(df$reclong))

  if (any(is.na(mass_num) & !is.na(df$mass..g.))) {
    stop("`mass..g.` contains values that cannot be converted to numeric.", call. = FALSE)
  }

  if (any(is.na(year_num) & !is.na(df$year))) {
    stop("`year` contains values that cannot be converted to numeric.", call. = FALSE)
  }

  if (any(is.na(reclat_num) & !is.na(df$reclat))) {
    stop("`reclat` contains values that cannot be converted to numeric.", call. = FALSE)
  }

  if (any(is.na(reclong_num) & !is.na(df$reclong))) {
    stop("`reclong` contains values that cannot be converted to numeric.", call. = FALSE)
  }

  df %>%
    dplyr::mutate(
      mass = mass_num,
      year = year_num,
      reclat = reclat_num,
      reclong = reclong_num
    )
}

#' Filter meteorites with positive mass
#'
#' Keeps only rows with positive mass values.
#'
#' @param df A data frame containing a numeric `mass` column.
#'
#' @return A data frame containing only rows with `mass > 0`.
filter_positive_mass <- function(df) {
  df %>%
    dplyr::filter(mass > 0)
}

#' Add transformed meteorite columns
#'
#' Creates `log_mass` and converts `fall` and `recclass` to factors.
#'
#' @param df A data frame containing meteorite data with numeric `mass`.
#'
#' @return A data frame with `log_mass` added and factor `fall` and `recclass`.
add_meteorite_transforms <- function(df) {
  df %>%
    dplyr::mutate(
      log_mass = log10(mass),
      fall = as.factor(fall),
      recclass = as.factor(recclass)
    )
}

#'Filter meteorite data to top classes
#'
#' Keeps only the top n most frequent meteorite classes in the recclass
#' column of a cleaned dataframe.
#' 
#' @param df A cleaned meteorite dataframe containing a recclass column.
#' @param n An integer specifying how many of the most frequent classes to keep.
#' Default is 5.
#'
#' @return A filtered dataframe containing only rows whose recclass is among
#' the top n most common classes.

filter_top_classes <- function(df, n = 5) {
  if (!is.data.frame(df)) {
    stop("`df` must be a data frame.", call. = FALSE)
  } 
  if (!"recclass" %in% names(df)) {
    stop("`df` must contain a `recclass` column.", call. = FALSE)
  }
  if (!is.numeric(n) || length(n) != 1 || is.na(n) || n <= 0 || n != as.integer(n)) {
    stop("`n` must be a single positive integer.", call. = FALSE)
  }

  top_classes <- df %>%
    dplyr::count(recclass, sort = TRUE) %>%
    dplyr::slice_head(n = n) %>%
    dplyr::pull(recclass)

  df %>%
    dplyr::filter(recclass %in% top_classes)
}


