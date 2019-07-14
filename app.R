library(shiny)
library(imager)

sample_images <- c("parrots", "hubble", "birds", "coins")

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput("image_name", "image", sample_images)),
    mainPanel(
      plotOutput(outputId = "distPlot"))))

server <- function(input, output) {
  output$distPlot <- renderPlot({
    plot(load.example(input$image_name))
  })
}

shinyApp(ui, server)
