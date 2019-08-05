sample_images <- c("parrots", "hubble", "birds")

reduce_pixel <- function(image, max_width) {
  w <- width(image)
  h <- height(image)
  if (w <= max_width) {
    image
  } else {
    resize(image, max_width, max_width * h / w)
  }
}

with_loading_message <- function(ui_element, message) {
  div(
    ui_element,
    p(message, class = "loading-message"),
    class = "loading-container"
  )
}

#' @import shiny
app_ui <- function() {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here 
    fluidPage(
      sidebarLayout(
        sidebarPanel(
          plotOutput("histogram"),
          plotOutput("tone_curve"),
          sliderInput("contrast", "Contrast", -1, 1, 0, step = 0.1),
          sliderInput("luminance", "Luminance", -1, 1, 0, step = 0.1),
          selectInput("image_name", "Image", sample_images),
          style = "height: 100vh; overflow-y: auto"
        ),
        mainPanel(
          with_loading_message(plotOutput("dist_image", height = "100vh"),
                               "loading...")
        ),
        position = "right"
      )
    )
  )
}

#' @import shiny
golem_add_external_resources <- function(){
  addResourcePath(
    'www', system.file('app/www', package = 'lroom')
  )

  tags$head(
    golem::activate_js(),
    # Add here all the external resources
    # If you have a custom.css in the inst/app/www
    # Or for example, you can add shinyalert::useShinyalert() here
    tags$link(rel = "stylesheet", type = "text/css", href = "www/custom.css")
  )
}
