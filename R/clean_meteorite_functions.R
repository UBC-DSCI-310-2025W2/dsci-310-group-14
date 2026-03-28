# Clean meteorite data
#
# Takes a raw meteorite dataframe and cleans it by removing rows with
# missing required values, converting selected columns to numeric,
# filtering out non-positive masses, and creating transformed columns.
#
# @param df A dataframe containing raw meteorite data.
#
# @return A cleaned dataframe with numeric mass, year, reclat, and reclong
# columns, a log_mass column, and factor fall and recclass columns.

clean_meteorite_data <- function(df) {
  df %>%
    tidyr::drop_na(mass..g., year, reclat, reclong, fall, recclass) %>%
    dplyr::mutate(
      mass = as.numeric(mass..g.),
      year = as.numeric(year),
      reclat = as.numeric(reclat),
      reclong = as.numeric(reclong)
    ) %>%
    tidyr::drop_na(mass, year, reclat, reclong) %>%
    dplyr::filter(mass > 0) %>%
    dplyr::mutate(
      log_mass = log10(mass),
      fall = as.factor(fall),
      recclass = as.factor(recclass)
    )
}

# Filter meteorite data to top classes
#
# Keeps only the top n most frequent meteorite classes in the recclass
# column of a cleaned dataframe.
#
# @param df A cleaned meteorite dataframe containing a recclass column.
# @param n An integer specifying how many of the most frequent classes to keep.
# Default is 5.
#
# @return A filtered dataframe containing only rows whose recclass is among
# the top n most common classes.
filter_top_classes <- function(df, n = 5) {
  top_classes <- df %>%
    dplyr::count(recclass, sort = TRUE) %>%
    dplyr::slice_head(n = n) %>%
    dplyr::pull(recclass)

  df %>%
    dplyr::filter(recclass %in% top_classes)
}