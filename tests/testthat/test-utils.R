test_that("initBins is a data.frame with one column of 13 rows", {
  expect_s3_class(QRAGadget:::initBins, "data.frame")
  expect_equal(ncol(QRAGadget:::initBins), 1)
  expect_equal(nrow(QRAGadget:::initBins), 13)
})

test_that("initBins values are strictly increasing", {
  vals <- QRAGadget:::initBins[[1]]
  expect_true(all(diff(vals) > 0))
})

test_that("sample is a data.frame with 36 rows and 36 columns", {
  expect_s3_class(QRAGadget:::sample, "data.frame")
  expect_equal(nrow(QRAGadget:::sample), 36)
  expect_equal(ncol(QRAGadget:::sample), 36)
})

test_that("data cleaning replaces zeros with NA", {
  m <- matrix(c(0, 1, 2, 0, 3, 0), nrow = 2)
  df <- data.frame(m)
  df[df == 0] <- NA
  expect_equal(sum(is.na(df)), 3)
  expect_equal(sum(!is.na(df)), 3)
})
