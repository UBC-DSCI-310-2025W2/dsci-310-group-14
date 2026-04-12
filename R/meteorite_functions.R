# Functions for modeling meteorite landing data.

#' Fit a generalized linear model for meteorite mass prediction
#'
#' Fits a generalized linear model (GLM) with a Gaussian family
#' to predict the log-transformed mass of meteorites based on year,
#' meteorite class, latitude, longitude, and fall type.
#' The model includes an interaction term between year and meteorite class.
#'
#' @param train_data A data frame containing meteorite training data with
#'   the following required columns: `log_mass` (numeric), `year` (numeric),
#'   `recclass` (factor or character), `reclat` (numeric), `reclong` (numeric),
#'   and `fall` (factor or character).
#'
#' @return A fitted GLM object of class `"glm"` that can be used for predictions.
#'
#' @details
#' The model formula is:
#' `log_mass ~ year * recclass + reclat + reclong + fall`
#'
#' This formula includes:
#' - Main effect of year
#' - Main effect of meteorite class (recclass)
#' - Interaction between year and meteorite class
#' - Main effects for latitude (reclat) and longitude (reclong)
#' - Main effect for fall type
#'
#' @examples
#' train_data <- data.frame(
#'   log_mass = c(1, 2, 3, 4, 5, 6),
#'   year = c(1990, 1995, 2000, 2005, 2010, 2015),
#'   recclass = c("L5", "H4", "L5", "H4", "LL6", "LL6"),
#'   reclat = c(10, 20, 30, 40, 50, 60),
#'   reclong = c(100, 110, 120, 130, 140, 150),
#'   fall = c("Fell", "Found", "Fell", "Found", "Fell", "Found")
#' )
#' model <- fit_meteorite_model(train_data)

fit_meteorite_model <- function(train_data) {
  required_cols <- c("log_mass", "year", "recclass", "reclat", "reclong", "fall")
  
  missing_cols <- setdiff(required_cols, names(train_data))
  if (length(missing_cols) > 0) {
    stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
  }
  
  train_data$fall <- as.factor(train_data$fall)
  train_data$recclass <- as.factor(train_data$recclass)
  
  glm(
    log_mass ~ year * recclass + reclat + reclong + fall,
    data = train_data,
    family = gaussian()
  )
}
