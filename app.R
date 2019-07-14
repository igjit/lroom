library(shiny)
library(imager)

sample_images <- c("parrots", "hubble", "birds", "coins")

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput("image_name", "image", sample_images)),
    mainPanel(
      imageOutput(outputId = "dist_image"))))

server <- function(input, output) {
  output$dist_image <- renderImage({
    outfile <- tempfile(fileext = ".png")
    image <- load.example(input$image_name)
    save.image(image, outfile)

    list(src = outfile,
         contentType = "image/png",
         width = nrow(image),
         height = ncol(image))
  }, deleteFile = TRUE)
}

shinyApp(ui, server)
