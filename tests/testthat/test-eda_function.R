# tests/testthat/test-eda_functions.R
# Unit tests for plot_year_vs_log_mass() and save_plot() from R/eda_function.R

library(testthat)
library(ggplot2)

source(file.path("..", "..", "R", "eda_function.R"))

# plot_year_vs_log_mass()

# Simple test cases
test_that("plot_year_vs_log_mass() returns a ggplot object for valid input", {
  meteors <- data.frame(
    year     = c(1900, 1950, 1980, 2000, 2010),
    log_mass = c(2.1, 3.4, 1.8, 4.0, 2.7))
  result <- plot_year_vs_log_mass(meteors)
  expect_s3_class(result, "ggplot")})

test_that("plot_year_vs_log_mass() sets the correct title and axis labels", {
  meteors <- data.frame(
    year     = c(1900, 1950, 1980, 2000, 2010),
    log_mass = c(2.1, 3.4, 1.8, 4.0, 2.7))
  result <- plot_year_vs_log_mass(meteors)
  expect_equal(result$labels$title, "Year vs Log10(Mass)")
  expect_equal(result$labels$x, "Year")
  expect_equal(result$labels$y, "Log10(Mass)")})

# Edge test cases
test_that("plot_year_vs_log_mass() works with a single-row data frame", {
  single_row <- data.frame(year = 1975, log_mass = 3.0)
  result <- plot_year_vs_log_mass(single_row)
  expect_s3_class(result, "ggplot")})

test_that("plot_year_vs_log_mass() works when year and log_mass contain NA values", {
  meteors_with_na <- data.frame(
    year     = c(1900, NA, 2000),
    log_mass = c(2.1, 3.4, NA))
  result <- plot_year_vs_log_mass(meteors_with_na)
  expect_s3_class(result, "ggplot")})

# Error test cases
test_that("plot_year_vs_log_mass() throws an error when input is not a data frame", {
  not_a_df <- list(year = c(1900, 1950), log_mass = c(2.1, 3.4))
  expect_error(plot_year_vs_log_mass(not_a_df), "`df` must be a data frame.")})

test_that("plot_year_vs_log_mass() throws an error when required columns are missing", {
  missing_log_mass <- data.frame(year = c(1900, 1950), mass = c(100, 200))
  expect_error(plot_year_vs_log_mass(missing_log_mass),
               "The following required columns are missing: log_mass")})

# save_plot()

# Simple test cases
test_that("save_plot() creates a PNG file at the expected path", {
  p <- plot_year_vs_log_mass(data.frame(year = c(1900, 1950), log_mass = c(2.1, 3.4)))
  tmp_prefix <- file.path(tempdir(), "test_output")
  save_plot(p, tmp_prefix, "_eda_plot")
  expect_true(file.exists(paste0(tmp_prefix, "_eda_plot.png")))
  file.remove(paste0(tmp_prefix, "_eda_plot.png"))})

test_that("save_plot() returns the output file path invisibly", {
  p <- plot_year_vs_log_mass(data.frame(year = c(1900, 1950), log_mass = c(2.1, 3.4)))
  tmp_prefix <- file.path(tempdir(), "test_output2")
  result <- save_plot(p, tmp_prefix, "_eda_plot")
  expect_equal(result, paste0(tmp_prefix, "_eda_plot.png"))
  file.remove(paste0(tmp_prefix, "_eda_plot.png"))})

# Edge test cases
test_that("save_plot() creates nested parent directories if they do not exist", {
  p <- plot_year_vs_log_mass(data.frame(year = c(1900, 1950), log_mass = c(2.1, 3.4)))
  tmp_prefix <- file.path(tempdir(), "new_subdir", "output")
  save_plot(p, tmp_prefix, "_eda_plot")
  expect_true(file.exists(paste0(tmp_prefix, "_eda_plot.png")))
  unlink(file.path(tempdir(), "new_subdir"), recursive = TRUE)})

test_that("save_plot() uses '_plot' as the default suffix when none is provided", {
  p <- plot_year_vs_log_mass(data.frame(year = c(1900, 1950), log_mass = c(2.1, 3.4)))
  tmp_prefix <- file.path(tempdir(), "test_default_suffix")
  save_plot(p, tmp_prefix)
  expect_true(file.exists(paste0(tmp_prefix, "_plot.png")))
  file.remove(paste0(tmp_prefix, "_plot.png"))})

# Error test cases
test_that("save_plot() throws an error when `plot` is not a ggplot object", {
  expect_error(save_plot("not_a_plot", file.path(tempdir(), "out"), "_eda_plot"),
               "`plot` must be a ggplot object.")})

test_that("save_plot() throws an error when `output_prefix` is not a string", {
  p <- plot_year_vs_log_mass(data.frame(year = c(1900, 1950), log_mass = c(2.1, 3.4)))
  expect_error(save_plot(p, 123, "_eda_plot"), 
               "`output_prefix` must be a single character string.")})