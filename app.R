library(shiny)
library(imager)

sample_images <- c("parrots", "hubble", "birds", "coins")

load_as_file <- function(name) {
  outfile <- tempfile(fileext = ".png")
  image <- load.example(name)
  save.image(image, outfile)
  outfile
}

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput("image_name", "image", sample_images)),
    mainPanel(
      imageOutput(outputId = "dist_image"))))

server <- function(input, output) {
  output$dist_image <- renderImage({
    image_file <- load_as_file(input$image_name)

    list(src = image_file,
         contentType = "image/png",
         width = nrow(image),
         height = ncol(image))
  }, deleteFile = TRUE)
}

shinyApp(ui, server)
