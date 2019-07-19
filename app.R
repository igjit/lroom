library(shiny)
library(imager)
library(dplyr)
library(ggplot2)

sample_images <- c("parrots", "hubble", "birds", "coins")

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      plotOutput("histogram"),
      plotOutput("tone_curve"),
      sliderInput("contrast", "Contrast", -1, 1, 0, step = 0.1),
      selectInput("image_name", "image", sample_images)),
    mainPanel(
      plotOutput("dist_image")),
    position = "right"))

server <- function(input, output) {
  image <- reactive(load.example(input$image_name))
  output$dist_image <- renderPlot({
    plot(as.raster(image()))
  })
  output$histogram <- renderPlot({
    color_df <- image() %>%
      as.data.frame %>%
      mutate(color = c("r", "g", "b")[cc])
    ggplot(color_df, aes(x = value, fill = color)) +
      geom_histogram(position = "identity", alpha = 0.5, show.legend = FALSE) +
      scale_fill_manual(values = c(r = "red", g = "green", b = "blue"))
  })
  output$tone_curve <- renderPlot({
    dy <- 0.1 * input$contrast
    xs <- c(0, 0.25, 0.75, 1.0)
    ys <- c(0, 0.25 - dy, 0.75 + dy, 1.0)
    fun <- splinefun(xs, ys)
    ggplot() +
      stat_function(aes(x = 0:1), fun = fun)
  })
}

shinyApp(ui, server)
