library(testthat)
library(tidyverse)

source(file.path("..", "..", "R", "clean_meteorite_functions.R"))

test_that("clean_meteorite_data removes invalid rows and adds transformed columns", {
  test_df <- tibble(
    mass..g. = c("10", "0", NA, "100"),
    year = c("2001", "2002", "2003", "2004"),
    reclat = c("1", "2", "3", "4"),
    reclong = c("5", "6", "7", "8"),
    fall = c("Fell", "Found", "Fell", "Found"),
    recclass = c("L5", "L5", "H6", "H6")
  )

  result <- clean_meteorite_data(test_df)

  expect_true("mass" %in% names(result))
  expect_true("log_mass" %in% names(result))
  expect_true(is.numeric(result$mass))
  expect_true(is.numeric(result$year))
  expect_true(is.numeric(result$reclat))
  expect_true(is.numeric(result$reclong))
  expect_true(is.factor(result$fall))
  expect_true(is.factor(result$recclass))
  expect_true(all(result$mass > 0))
  expect_equal(nrow(result), 2)
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