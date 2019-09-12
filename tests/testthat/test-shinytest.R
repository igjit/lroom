library(shinytest)

skip_on_covr()

app <- ShinyDriver$new(".")

test_that("contrast_ui works", {
  expectUpdate(app, "contrast_ui_1-contrast" = 1, output = "image_ui_1-image")
  expectUpdate(app, "luminance_ui_1-luminance" = 1, output = "image_ui_1-image")
})

app$stop()
