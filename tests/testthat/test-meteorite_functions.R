library(testthat)

source(here::here("R", "meteorite_functions.R"))


test_that("fit_meteorite_model returns a glm object", {
  train_data <- data.frame(
    log_mass = c(1, 2, 3, 4, 5, 6),
    year = c(1990, 1995, 2000, 2005, 2010, 2015),
    recclass = c("L5", "H4", "L5", "H4", "LL6", "LL6"),
    reclat = c(10, 20, 30, 40, 50, 60),
    reclong = c(100, 110, 120, 130, 140, 150),
    fall = c("Fell", "Found", "Fell", "Found", "Fell", "Found")
  )

  model <- fit_meteorite_model(train_data)

  expect_s3_class(model, "glm")
})

test_that("fit_meteorite_model errors when required columns are missing", {
  bad_data <- data.frame(
    log_mass = c(1, 2, 3),
    year = c(2000, 2001, 2002),
    recclass = c("L5", "H4", "LL6"),
    reclat = c(10, 20, 30),
    fall = c("Fell", "Found", "Fell")
  )

  expect_error(fit_meteorite_model(bad_data), "Missing required columns")
})
