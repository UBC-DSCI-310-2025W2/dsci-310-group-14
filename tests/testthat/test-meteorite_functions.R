# tests/testthat/test-meteorite_functions.R
# Unit tests for fit_meteorite_model() from R/meteorite_functions.R

library(testthat)

source(here::here("R", "meteorite_functions.R"))

# fit_meteorite_model()

# Simple test cases
test_that("fit_meteorite_model returns a glm object for valid input", {
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

test_that("fit_meteorite_model uses the correct model formula", {
  train_data <- data.frame(
    log_mass = c(1, 2, 3, 4, 5, 6),
    year = c(1990, 1995, 2000, 2005, 2010, 2015),
    recclass = c("L5", "H4", "L5", "H4", "LL6", "LL6"),
    reclat = c(10, 20, 30, 40, 50, 60),
    reclong = c(100, 110, 120, 130, 140, 150),
    fall = c("Fell", "Found", "Fell", "Found", "Fell", "Found")
  )

  model <- fit_meteorite_model(train_data)
  
  # Check that the model formula contains the expected terms
  expect_true(grepl("year \\* recclass", as.character(model$formula)))
  expect_true(grepl("reclat", as.character(model$formula)))
  expect_true(grepl("reclong", as.character(model$formula)))
  expect_true(grepl("fall", as.character(model$formula)))
})

test_that("fit_meteorite_model uses Gaussian family for GLM", {
  train_data <- data.frame(
    log_mass = c(1, 2, 3, 4, 5, 6),
    year = c(1990, 1995, 2000, 2005, 2010, 2015),
    recclass = c("L5", "H4", "L5", "H4", "LL6", "LL6"),
    reclat = c(10, 20, 30, 40, 50, 60),
    reclong = c(100, 110, 120, 130, 140, 150),
    fall = c("Fell", "Found", "Fell", "Found", "Fell", "Found")
  )

  model <- fit_meteorite_model(train_data)
  
  expect_equal(model$family$family, "gaussian")
})

# Edge test cases
test_that("fit_meteorite_model works with character recclass and fall columns", {
  train_data <- data.frame(
    log_mass = c(1, 2, 3, 4, 5, 6),
    year = c(1990, 1995, 2000, 2005, 2010, 2015),
    recclass = c("L5", "H4", "L5", "H4", "LL6", "LL6"),
    reclat = c(10, 20, 30, 40, 50, 60),
    reclong = c(100, 110, 120, 130, 140, 150),
    fall = c("Fell", "Found", "Fell", "Found", "Fell", "Found")
  )

  # Ensure columns are character, not factor
  train_data$recclass <- as.character(train_data$recclass)
  train_data$fall <- as.character(train_data$fall)
  
  model <- fit_meteorite_model(train_data)
  
  expect_s3_class(model, "glm")
})

test_that("fit_meteorite_model works with factor recclass and fall columns", {
  train_data <- data.frame(
    log_mass = c(1, 2, 3, 4, 5, 6),
    year = c(1990, 1995, 2000, 2005, 2010, 2015),
    recclass = factor(c("L5", "H4", "L5", "H4", "LL6", "LL6")),
    reclat = c(10, 20, 30, 40, 50, 60),
    reclong = c(100, 110, 120, 130, 140, 150),
    fall = factor(c("Fell", "Found", "Fell", "Found", "Fell", "Found"))
  )

  model <- fit_meteorite_model(train_data)
  
  expect_s3_class(model, "glm")
})

# Error test cases
test_that("fit_meteorite_model errors when required columns are missing", {
  bad_data <- data.frame(
    log_mass = c(1, 2, 3),
    year = c(2000, 2001, 2002),
    recclass = c("L5", "H4", "LL6"),
    reclat = c(10, 20, 30),
    fall = c("Fell", "Found", "Fell")
  )

  expect_error(fit_meteorite_model(bad_data), "Missing required columns: reclong")
})

test_that("fit_meteorite_model errors when multiple columns are missing", {
  bad_data <- data.frame(
    log_mass = c(1, 2, 3),
    year = c(2000, 2001, 2002),
    recclass = c("L5", "H4", "LL6")
  )

  expect_error(fit_meteorite_model(bad_data), "Missing required columns")
})

test_that("fit_meteorite_model errors when log_mass column is missing", {
  bad_data <- data.frame(
    year = c(1990, 1995, 2000, 2005, 2010, 2015),
    recclass = c("L5", "H4", "L5", "H4", "LL6", "LL6"),
    reclat = c(10, 20, 30, 40, 50, 60),
    reclong = c(100, 110, 120, 130, 140, 150),
    fall = c("Fell", "Found", "Fell", "Found", "Fell", "Found")
  )

  expect_error(fit_meteorite_model(bad_data), "Missing required columns: log_mass")
})
