test_that("labelFormat2 returns a function", {
  fmt <- QRAGadget:::labelFormat2()
  expect_true(is.function(fmt))
})

test_that("labelFormat2 formats numeric cuts in scientific notation", {
  fmt <- QRAGadget:::labelFormat2(digits = 3)
  result <- fmt("numeric", c(1e-10, 1e-8, 1e-6))
  expect_true(all(grepl("e", result, ignore.case = TRUE)))
})

test_that("labelFormat2 formats bin cuts as ranges", {
  fmt <- QRAGadget:::labelFormat2(digits = 3)
  result <- fmt("bin", c(1e-10, 1e-8, 1e-6))
  expect_length(result, 2)
  expect_true(all(grepl("&ndash;", result)))
})

test_that("labelFormat2 prefix and suffix are applied", {
  fmt <- QRAGadget:::labelFormat2(prefix = "<<", suffix = ">>")
  result <- fmt("numeric", c(1e-5))
  expect_true(grepl("^<<", result))
  expect_true(grepl(">>$", result))
})
