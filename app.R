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
  image <- reactive(load.example(input$image_name))
  output$dist_image <- renderPlot({
    plot(image())
  })
}

shinyApp(ui, server)
