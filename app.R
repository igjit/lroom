library(shiny)
library(imager)

sample_images <- c("parrots", "hubble", "birds", "coins")

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput("image_name", "image", sample_images)),
    mainPanel(
      plotOutput(outputId = "dist_image"))))

server <- function(input, output) {
  output$dist_image <- renderPlot({
    plot(load.example(input$image_name))
  })
}

shinyApp(ui, server)
