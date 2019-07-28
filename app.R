library(shiny)
library(imager)
library(dplyr)
library(ggplot2)

sample_images <- c("parrots", "hubble", "birds", "coins")

reduce_pixel <- function(image, max_width) {
  w <- width(image)
  h <- height(image)
  if (w <= max_width) {
    image
  } else {
    resize(image, max_width, max_width * h / w)
  }
}

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      plotOutput("histogram"),
      plotOutput("tone_curve"),
      sliderInput("contrast", "Contrast", -1, 1, 0, step = 0.1),
      sliderInput("luminance", "Luminance", -1, 1, 0, step = 0.1),
      selectInput("image_name", "image", sample_images)
    ),
    mainPanel(
      plotOutput("dist_image", height = "100vh")
    ),
    position = "right"
  )
)

server <- function(input, output) {
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
  output$histogram <- renderPlot({
    color_df <- adjusted_image() %>%
      reduce_pixel(100) %>%
      as.data.frame %>%
      mutate(color = c("r", "g", "b")[cc])
    ggplot(color_df, aes(x = value, fill = color)) +
      geom_histogram(position = "identity", alpha = 0.5, show.legend = FALSE) +
      scale_fill_manual(values = c(r = "red", g = "green", b = "blue"))
  })
  output$tone_curve <- renderPlot({
    points <- tone_curve_points()
    ggplot() +
      stat_function(aes(x = 0:1), fun = tone_curve()) +
      geom_point(aes(points$x, points$y))
  })
}

shinyApp(ui, server)
