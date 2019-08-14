#' @import shiny
app_server <- function(input, output, session) {
  image <- callModule(mod_sample_image_server, "sample_image_ui_1")
  tone_curve_points <- callModule(mod_contrast_server, "contrast_ui_1")
  tone_curve <- reactive({
    points <- tone_curve_points()
    splinefun(points$x, points$y)
  })
  tone_image <- reactive(apply_tone_curve(image(), tone_curve()))
  luminance_image <- callModule(mod_luminance_server, "luminance_ui_1", tone_image)
  callModule(mod_histogram_server, "histogram_ui_1", luminance_image)
  callModule(mod_tone_curve_server, "tone_curve_ui_1", tone_curve_points, tone_curve)
  callModule(mod_image_server, "image_ui_1", luminance_image)
}
