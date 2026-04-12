# Functions for exploratory data analysis of meteorite landing data.

#' Plot year vs log10(mass) for meteorite landing data
#'
#' Creates a scatter plot of the year a meteorite was found against
#' the log10-transformed mass of the meteorite. Each point represents
#' one meteorite observation.
#'
#' @param df A data frame containing the columns: `year` (numeric)
#'   and `log_mass` (numeric).
#'
#' @return A ggplot object with `year` on the x-axis and `log_mass` on the
#'   y-axis, rendered as a scatter plot.
#'
#' @export
#'
#' @examples
#' meteors <- data.frame(year = c(1900, 1950, 2000), log_mass = c(2.1, 3.4, 1.8))
#' plot_year_vs_log_mass(meteors)
plot_year_vs_log_mass <- function(df) {
  if (!is.data.frame(df)) {
    stop("`df` must be a data frame.")
  }
  
  required_cols <- c("year", "log_mass")
  missing_cols <- setdiff(required_cols, colnames(df))
  if (length(missing_cols) > 0) {
    stop(
      "The following required columns are missing: ",
      paste(missing_cols, collapse = ", ")
    )
  }
  
  ggplot2::ggplot(df, ggplot2::aes(x = year, y = log_mass)) +
    ggplot2::geom_point(alpha = 0.3) +
    ggplot2::labs(
      title = "Year vs Log10(Mass)",
      x = "Year",
      y = "Log10(Mass)"
    )
}

#' Save a ggplot object to a PNG file
#'
#' Saves a ggplot object to disk as a PNG file, constructing the output path
#' from a prefix and suffix. Creates any necessary parent directories.
#'
#' @param plot A ggplot object to save.
#' @param output_prefix A single character string for the directory and filename
#'   prefix (e.g. `"results/eda"`).
#' @param suffix A single character string appended between the prefix and
#'   `.png` (e.g. `"_eda_plot"`). Defaults to `"_plot"`.
#'
#' @return The full output file path (invisibly).
#'
#' @export
#'
#' @examples
#' \dontrun{
#' meteors <- data.frame(year = c(1900, 1950, 2000), log_mass = c(2.1, 3.4, 1.8))
#' p <- plot_year_vs_log_mass(meteors)
#' save_plot(p, "results/eda", "_eda_plot")
#' }
save_plot <- function(plot, output_prefix, suffix = "_plot") {
  if (!inherits(plot, "gg")) {
    stop("`plot` must be a ggplot object.")
  }
  
  if (!is.character(output_prefix) || length(output_prefix) != 1) {
    stop("`output_prefix` must be a single character string.")
  }
  
  if (!is.character(suffix) || length(suffix) != 1) {
    stop("`suffix` must be a single character string.")
  }
  
  out_path <- paste0(output_prefix, suffix, ".png")
  dir.create(dirname(out_path), recursive = TRUE, showWarnings = FALSE)
  ggplot2::ggsave(out_path, plot = plot)
  
  invisible(out_path)
}