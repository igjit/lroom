# Module UI

#' @title   mod_tone_curve_ui and mod_tone_curve_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_tone_curve
#'
#' @keywords internal
#' @export
#' @importFrom shiny NS tagList
mod_tone_curve_ui <- function(id) {
  ns <- NS(id)
  plotOutput(ns("tone_curve"))
}

# Module Server

#' @rdname mod_tone_curve
#' @export
#' @keywords internal
mod_tone_curve_server <- function(input, output, session, tone_curve_points, tone_curve) {
  output$tone_curve <- renderPlot({
    points <- tone_curve_points()
    ggplot() +
      stat_function(aes(x = 0:1), fun = tone_curve()) +
      geom_point(aes(points$x, points$y))
  })
}
