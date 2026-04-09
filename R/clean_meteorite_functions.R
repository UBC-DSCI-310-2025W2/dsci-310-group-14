#' Clean meteorite data
#'
#' Takes a raw meteorite dataframe and cleans it by removing rows with
#' missing required values, converting selected columns to numeric,
#' filtering out non-positive masses, and creating transformed columns.
#'
#' @param df A dataframe containing raw meteorite data.
#'
#' @return A cleaned dataframe with numeric mass, year, reclat, and reclong
#' columns, a log_mass column, and factor fall and recclass columns.

clean_meteorite_data <- function(df) {
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

  df_no_na <- df %>%
    tidyr::drop_na(mass..g., year, reclat, reclong, fall, recclass)

    mass_num <- suppressWarnings(as.numeric(df_no_na$mass..g.))
    year_num <- suppressWarnings(as.numeric(df_no_na$year))
    reclat_num <- suppressWarnings(as.numeric(df_no_na$reclat))
    reclong_num <- suppressWarnings(as.numeric(df_no_na$reclong)) 

  if (any(is.na(mass_num) & !is.na(df_no_na$mass..g.))) {
    stop("`mass..g.` contains values that cannot be converted to numeric.", call. = FALSE)
  }
  
  if (any(is.na(year_num) & !is.na(df_no_na$year))) {
    stop("`year` contains values that cannot be converted to numeric.", call. = FALSE)
  }

  if (any(is.na(reclat_num) & !is.na(df_no_na$reclat))) {
    stop("`reclat` contains values that cannot be converted to numeric.", call. = FALSE)
  }

  if (any(is.na(reclong_num) & !is.na(df_no_na$reclong))) {
    stop("`reclong` contains values that cannot be converted to numeric.", call. = FALSE)
  }

 df_no_na %>%
    dplyr::mutate(
      mass = mass_num,
      year = year_num,
      reclat = reclat_num,
      reclong = reclong_num
    ) %>%
    dplyr::filter(mass > 0) %>%
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


