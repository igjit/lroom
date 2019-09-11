library(shinytest)

app <- ShinyDriver$new(".")

test_that("contrast_ui works", {
  expectUpdate(app, "contrast_ui_1-contrast" = 1, output = "image_ui_1-image")
})

app$stop()
