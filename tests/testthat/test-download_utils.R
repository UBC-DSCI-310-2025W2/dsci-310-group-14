library(testthat)

source(here::here("R", "download_utils.R"))

# ensure_dir

test_that("ensure_dir errors when path is not a character", {
  expect_error(ensure_dir(123),
  "`path` must be a single, non-empty character string.")

  expect_error(ensure_dir(TRUE),
  "`path` must be a single, non-empty character string.")

  expect_error(ensure_dir(NULL),
  "`path` must be a single, non-empty character string.") # nolint

  expect_error(ensure_dir(list("dir")),
  "`path` must be a single, non-empty character string.")
})

test_that("ensure_dir errors when path is NA", {
  expect_error(ensure_dir(NA_character_),
  "`path` must be a single, non-empty character string.")
})

test_that("ensure_dir errors when path is an empty string", {
  expect_error(ensure_dir(""),
  "`path` must be a single, non-empty character string.")
})

test_that("ensure_dir errors when path is a vector of length > 1", {
  expect_error(ensure_dir(c("a", "b")),
  "`path` must be a single, non-empty character string.")
})

test_that("ensure_dir creates a directory that does not yet exist", {
  tmp <- file.path(tempdir(), paste0("ensure_dir_test_", sample.int(1e6, 1)))
  on.exit(unlink(tmp, recursive = TRUE), add = TRUE)

  expect_false(dir.exists(tmp))
  ensure_dir(tmp)
  expect_true(dir.exists(tmp))
})

test_that("ensure_dir does not error when the directory already exists", {
  expect_no_error(ensure_dir(tempdir()))
})

test_that("download_url_copy errors when input is not a character", {
  expect_error(download_url_copy(123,  tempfile()), "`input` must be a single, non-empty character string.")
  expect_error(download_url_copy(NULL, tempfile()), "`input` must be a single, non-empty character string.")
})
 
test_that("download_url_copy errors when input is NA", {
  expect_error(download_url_copy(NA_character_, tempfile()),
               "`input` must be a single, non-empty character string.")
})
 
test_that("download_url_copy errors when input is an empty string", {
  expect_error(download_url_copy("", tempfile()),
               "`input` must be a single, non-empty character string.")
})
 
test_that("download_url_copy errors when output is not a character", {
  expect_error(download_url_copy("https://example.com", 123),
               "`output` must be a single, non-empty character string.")
})
 
test_that("download_url_copy errors when output is NA", {
  expect_error(download_url_copy("https://example.com", NA_character_),
               "`output` must be a single, non-empty character string.")
})
 
test_that("download_url_copy errors when output is an empty string", {
  expect_error(download_url_copy("https://example.com", ""),
               "`output` must be a single, non-empty character string.")
})
 
test_that("download_url_copy errors when local source file does not exist", {
  expect_error(download_url_copy("/no/such/file.csv", tempfile()),
               "Source file does not exist")
})
 
test_that("download_url_copy copies a local file to the destination", {
  src <- tempfile()
  dst <- tempfile()
  writeLines(c("name,mass", "Allende,2000"), src)
  on.exit({ unlink(src); unlink(dst) }, add = TRUE)
 
  download_url_copy(src, dst)
  expect_true(file.exists(dst))
  expect_equal(readLines(dst), c("name,mass", "Allende,2000"))
})
 
test_that("download_url_copy overwrites an existing destination file", {
  src <- tempfile()
  dst <- tempfile()
  writeLines("new content", src)
  writeLines("old content", dst)
  on.exit({ unlink(src); unlink(dst) }, add = TRUE)
 
  download_url_copy(src, dst)
  expect_equal(readLines(dst), "new content")
})
 
test_that("download_url_copy does not modify the source file", {
  src <- tempfile()
  dst <- tempfile()
  writeLines("original", src)
  on.exit({ unlink(src); unlink(dst) }, add = TRUE)
 
  download_url_copy(src, dst)
  expect_equal(readLines(src), "original")
})
 
test_that("download_url_copy downloads a remote URL to disk", {
  skip_if_offline()
  dst <- tempfile(fileext = ".md")
  on.exit(unlink(dst), add = TRUE)
 
  download_url_copy(
    input  = "https://raw.githubusercontent.com/tidyverse/ggplot2/main/NEWS.md",
    output = dst
  )
  expect_true(file.exists(dst))
  expect_gt(file.size(dst), 0)
})

# fetch_data

test_that("fetch_data errors when input is not a character", {
  expect_error(fetch_data(123,  tempfile()),
  "`input` must be a single, non-empty character string.")
  expect_error(fetch_data(NULL, tempfile()),
  "`input` must be a single, non-empty character string.")
})

test_that("fetch_data errors when input is NA", {
  expect_error(fetch_data(NA_character_, tempfile()),
               "`input` must be a single, non-empty character string.")
})

test_that("fetch_data errors when input is an empty string", {
  expect_error(fetch_data("", tempfile()),
               "`input` must be a single, non-empty character string.")
})

test_that("fetch_data errors when output is not a character", {
  src <- tempfile()
  writeLines("x", src)
  on.exit(unlink(src), add = TRUE)

  expect_error(fetch_data(src, 123),
  "`output` must be a single, non-empty character string.")
  expect_error(fetch_data(src, NULL),
  "`output` must be a single, non-empty character string.")
})

test_that("fetch_data errors when output is NA", {
  src <- tempfile()
  writeLines("x", src)
  on.exit(unlink(src), add = TRUE)

  expect_error(fetch_data(src, NA_character_),
               "`output` must be a single, non-empty character string.")
})

test_that("fetch_data copies a local file to the output path", {
  src <- tempfile()
  dst <- tempfile()
  writeLines(c("name,year", "Sikhote-Alin,1947"), src)
  on.exit({ unlink(src); unlink(dst) }, add = TRUE)

  fetch_data(src, dst)
  expect_true(file.exists(dst))
  expect_equal(readLines(dst), c("name,year", "Sikhote-Alin,1947"))
})

test_that("fetch_data creates a missing output directory for a local path", {
  src     <- tempfile()
  out_dir <- file.path(tempdir(), paste0("fetch_newdir_", sample.int(1e6, 1)))
  dst     <- file.path(out_dir, "data.csv")
  writeLines("a,b", src)
  on.exit({ unlink(src); unlink(out_dir, recursive = TRUE) }, add = TRUE)

  expect_false(dir.exists(out_dir))
  fetch_data(src, dst)
  expect_true(file.exists(dst))
})

test_that("fetch_data downloads a remote URL to the output path", {
  skip_if_offline()
  out_dir <- file.path(tempdir(), paste0("fetch_url_", sample.int(1e6, 1)))
  dst     <- file.path(out_dir, "news.md")
  on.exit(unlink(out_dir, recursive = TRUE), add = TRUE)

  fetch_data(
    input  = "https://raw.githubusercontent.com/tidyverse/ggplot2/main/NEWS.md",
    output = dst
  )
  expect_true(file.exists(dst))
  expect_gt(file.size(dst), 0)
})
