with_loading_message <- function(ui_element, message) {
  div(
    ui_element,
    p(message, class = "loading-message"),
    class = "loading-container"
  )
}
