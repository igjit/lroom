sample_images <- c("parrots", "hubble", "birds")

#' @import shiny
app_ui <- function() {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here
    fluidPage(
      sidebarLayout(
        sidebarPanel(
          mod_histogram_ui("histogram_ui_1"),
          mod_tone_curve_ui("tone_curve_ui_1"),
          mod_contrast_ui("contrast_ui_1"),
          mod_luminance_ui("luminance_ui_1"),
          selectInput("image_name", "Image", sample_images),
          style = "height: 100vh; overflow-y: auto"
        ),
        mainPanel(
          mod_image_ui("image_ui_1")
        ),
        position = "right"
      )
    )
  )
}

#' @import shiny
golem_add_external_resources <- function(){
  addResourcePath(
    "www", system.file("app/www", package = "lroom")
  )

  tags$head(
    golem::activate_js(),
    # Add here all the external resources
    # If you have a custom.css in the inst/app/www
    # Or for example, you can add shinyalert::useShinyalert() here
    tags$link(rel = "stylesheet", type = "text/css", href = "www/custom.css")
  )
}
