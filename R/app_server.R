#' @import shiny
app_server <- function(input, output, session) {
  image <- reactive(load.example(input$image_name))
  tone_curve_points <- reactive({
    dy <- 0.1 * input$contrast
    xs <- c(0, 0.25, 0.75, 1.0)
    ys <- c(0, 0.25 - dy, 0.75 + dy, 1.0)
    list(x = xs, y = ys)
  })
  tone_curve <- reactive({
    points <- tone_curve_points()
    splinefun(points$x, points$y)
  })
  tone_image <- reactive(apply_tone_curve(image(), tone_curve()))
  adjusted_image <- reactive(apply_luminance(tone_image(), input$luminance))
  callModule(mod_histogram_server, "histogram_ui_1", adjusted_image)
  callModule(mod_tone_curve_server, "tone_curve_ui_1", tone_curve_points, tone_curve)
  callModule(mod_image_server, "image_ui_1", adjusted_image)
}
