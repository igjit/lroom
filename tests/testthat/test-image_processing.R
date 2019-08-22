context("image_processing.R")

test_that("reduce_pixel", {
  image <- imager::boats
  expect_equal(dim(reduce_pixel(image, 100)), c(100, 150, 1, 3))
  expect_equal(dim(reduce_pixel(image, 1000)), c(256, 384, 1, 3))
})

test_that("apply_luminance", {
  image <- imager::boats
  luminance_before <- image %>% as.vector %>% mean
  expect_gt(apply_luminance(image, 0.5) %>% as.vector %>% mean, luminance_before)
  expect_lt(apply_luminance(image, -0.5) %>% as.vector %>% mean, luminance_before)
})
