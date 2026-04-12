library(testthat)
library(tidyverse)

source("../../R/clean_meteorite_functions.R")

test_that("clean_meteorite_data removes invalid rows and adds transformed columns", {
  test_df <- tibble(
    mass..g. = c("10", "20"),
    year = c("2001", "2002"),
    reclat = c("1", "2"),
    reclong = c("5", "6"),
    fall = c("Fell", "Found"),
    recclass = c("L5", "L5")
  )
  
  expect_invisible(validate_meteorite_columns(test_df))
})


test_that("validate_meteorite_columns errors if input is not a data frame", {
  expect_error(
    validate_meteorite_columns("not_a_dataframe"),
    "`df` must be a data frame."
  )
})

test_that("validate_meteorite_columns errors if required columns are missing", {
  bad_df <- tibble(
    year = c("2001", "2002"),
    reclat = c("1", "2"),
    reclong = c("5", "6")
  )

  expect_error(
    validate_meteorite_columns(bad_df),
    "Missing required columns:"
  )
})

test_that("filter_valid_meteorite_rows removes rows with missing required values", {
  test_df <- tibble(
    mass..g. = c("10", NA, "100"),
    year = c("2001", "2002", "2004"),
    reclat = c("1", "2", "4"),
    reclong = c("5", "6", "8"),
    fall = c("Fell", "Found", "Found"),
    recclass = c("L5", "L5", "H6")
  )
  
  result <- filter_valid_meteorite_rows(test_df)

  expect_equal(nrow(result), 2)
  expect_equal(result$mass..g., c("10", "100"))
})

test_that("convert_meteorite_numeric converts selected columns to numeric", {
  test_df <- tibble(
    mass..g. = c("10", "100"),
    year = c("2001", "2004"),
    reclat = c("1", "4"),
    reclong = c("5", "8"),
    fall = c("Fell", "Found"),
    recclass = c("L5", "H6")
  )

  result <- convert_meteorite_numeric(test_df)

  expect_equal(result$mass, c(10, 100))
  expect_equal(result$year, c(2001, 2004))
  expect_equal(result$reclat, c(1, 4))
  expect_equal(result$reclong, c(5, 8))
  expect_true(is.numeric(result$mass))
  expect_true(is.numeric(result$year))
  expect_true(is.numeric(result$reclat))
  expect_true(is.numeric(result$reclong))
})

test_that("convert_meteorite_numeric errors if mass conversion fails", {
  bad_df <- tibble(
    mass..g. = c("10", "abc"),
    year = c("2001", "2002"),
    reclat = c("1", "2"),
    reclong = c("5", "6"),
    fall = c("Fell", "Found"),
    recclass = c("L5", "H6")
  )

  expect_error(
    convert_meteorite_numeric(bad_df),
    "`mass..g.` contains values that cannot be converted to numeric."
  )
})

test_that("filter_positive_mass removes non-positive mass rows", {
  test_df <- tibble(
    mass = c(10, 0, -5, 100),
    year = c(2001, 2002, 2003, 2004),
    reclat = c(1, 2, 3, 4),
    reclong = c(5, 6, 7, 8),
    fall = c("Fell", "Found", "Fell", "Found"),
    recclass = c("L5", "L5", "H6", "H6")
  )

  result <- filter_positive_mass(test_df)

  expect_equal(result$mass, c(10, 100))
  expect_true(all(result$mass > 0))
})

test_that("add_meteorite_transforms adds log_mass and factor columns", {
  test_df <- tibble(
    mass = c(10, 100),
    year = c(2001, 2004),
    reclat = c(1, 4),
    reclong = c(5, 8),
    fall = c("Fell", "Found"),
    recclass = c("L5", "H6")
  )

  result <- add_meteorite_transforms(test_df)

  expect_equal(result$log_mass, log10(c(10, 100)))
  expect_true(is.factor(result$fall))
  expect_true(is.factor(result$recclass))
  expect_equal(as.character(result$fall), c("Fell", "Found"))
  expect_equal(as.character(result$recclass), c("L5", "H6"))
})

test_that("meteorite cleaning pipeline works correctly when helper functions are chained", {
  test_df <- tibble(
    mass..g. = c("10", "0", NA, "100"),
    year = c("2001", "2002", "2003", "2004"),
    reclat = c("1", "2", "3", "4"),
    reclong = c("5", "6", "7", "8"),
    fall = c("Fell", "Found", "Fell", "Found"),
    recclass = c("L5", "L5", "H6", "H6")
  )

  validate_meteorite_columns(test_df)

  result <- test_df %>%
    filter_valid_meteorite_rows() %>%
    convert_meteorite_numeric() %>%
    filter_positive_mass() %>%
    add_meteorite_transforms()

  expect_equal(nrow(result), 2)
  expect_equal(result$mass, c(10, 100))
  expect_equal(result$year, c(2001, 2004))
  expect_equal(result$log_mass, log10(c(10, 100)))
  expect_true(is.factor(result$fall))
  expect_true(is.factor(result$recclass))
})


test_that("filter_top_classes keeps only the most common classes", {
  test_df <- tibble(
    recclass = factor(c("A", "A", "A", "B", "B", "C")),
    mass = c(1, 2, 3, 4, 5, 6),
    year = c(2001, 2002, 2003, 2004, 2005, 2006),
    reclat = c(1, 1, 1, 1, 1, 1),
    reclong = c(2, 2, 2, 2, 2, 2),
    fall = factor(c("Fell", "Fell", "Found", "Found", "Fell", "Found")),
    log_mass = log10(c(1, 2, 3, 4, 5, 6))
  )

  result <- filter_top_classes(test_df, n = 2)

  expect_true(all(result$recclass %in% c("A", "B")))
  expect_false(any(result$recclass %in% c("C")))
  expect_equal(nrow(result), 5)
})

test_that("filter_top_classes returns all rows when n is large enough", {
  test_df <- tibble(
    recclass = factor(c("A", "A", "B")),
    mass = c(1, 2, 3),
    year = c(2001, 2002, 2003),
    reclat = c(1, 1, 1),
    reclong = c(2, 2, 2),
    fall = factor(c("Fell", "Found", "Fell")),
    log_mass = log10(c(1, 2, 3))
  )

  result <- filter_top_classes(test_df, n = 5)

  expect_equal(nrow(result), 3)
})

test_that("filter_top_classes errors if input is not a data frame", {
  expect_error(
    filter_top_classes("not_a_dataframe"),
    "`df` must be a data frame."
  )
})

test_that("filter_top_classes errors if recclass column is missing", {
  bad_df <- tibble(
    mass = c(1, 2, 3)
  )

  expect_error(
    filter_top_classes(bad_df),
    "`df` must contain a `recclass` column."
  )
})

test_that("filter_top_classes errors if n is invalid", {
  df <- tibble(recclass = c("A", "A", "B"))

  expect_error(
    filter_top_classes(df, n = -1),
    "`n` must be a single positive integer."
  )

  expect_error(
    filter_top_classes(df, n = 2.5),
    "`n` must be a single positive integer."
  )

  expect_error(
    filter_top_classes(df, n = "five"),
    "`n` must be a single positive integer."
  )

  expect_error(
    filter_top_classes(df, n = NA),
    "`n` must be a single positive integer."
  )
})

test_that("remove_duplicate_rows removes duplicates", {
  df <- tibble(x = c(1, 1, 2))

  result <- remove_duplicate_rows(df)

  expect_equal(nrow(result), 2)
})

test_that("check_missingness errors when threshold exceeded", {
  df <- tibble(x = c(1, NA, NA))

  expect_error(
    check_missingness(df, threshold = 0.5),
    "Missingness exceeds threshold"
  )
})