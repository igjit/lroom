reduce_pixel <- function(image, max_width) {
  w <- width(image)
  h <- height(image)
  if (w <= max_width) {
    image
  } else {
    resize(image, max_width, max_width * h / w)
  }
}

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
  tone_image <- reactive({
    ycb_img <- RGBtoYCbCr(image())
    luma <- ycb_img[,, 1, 1]
    func <- tone_curve()
    adjusted <- luma %>% as.vector %>% `/`(256) %>% func %>% matrix(dim(luma))
    ton_img <- ycb_img
    ton_img[,, 1, 1] <- adjusted * 256
    YCbCrtoRGB(ton_img)
  })
  adjusted_image <- reactive({
    img <- tone_image()
    img[img < 0] <- 0
    img[img > 1] <- 1
    img ^ (10 ^ -input$luminance)
  })
  output$dist_image <- renderPlot({
    plot(as.raster(adjusted_image()))
  })
  callModule(mod_histogram_server, "histogram_ui_1", adjusted_image)
  callModule(mod_tone_curve_server, "tone_curve_ui_1", tone_curve_points, tone_curve)
}
