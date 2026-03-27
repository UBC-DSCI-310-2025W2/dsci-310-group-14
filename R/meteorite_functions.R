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
