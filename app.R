library(shiny)
library(imager)
library(dplyr)
library(ggplot2)

sample_images <- c("parrots", "hubble", "birds", "coins")

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      plotOutput(outputId = "histogram"),
      selectInput("image_name", "image", sample_images)),
    mainPanel(
      plotOutput(outputId = "dist_image")),
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
      geom_histogram(position = "identity", alpha = 0.5) +
      scale_fill_manual(values = c(r = "red", g = "green", b = "blue"))
  })
}

shinyApp(ui, server)
