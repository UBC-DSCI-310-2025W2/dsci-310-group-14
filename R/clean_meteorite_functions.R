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

filter_top_classes <- function(df, n = 5) {
  top_classes <- df %>%
    dplyr::count(recclass, sort = TRUE) %>%
    dplyr::slice_head(n = n) %>%
    dplyr::pull(recclass)

  df %>%
    dplyr::filter(recclass %in% top_classes)
}