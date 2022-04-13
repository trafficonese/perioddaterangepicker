#' Register an InputHandler
#' @importFrom shiny registerInputHandler
#' @noRd
.onLoad <- function(...) {
  shiny::registerInputHandler("PeriodDateRangePickerBinding", function(data, ...) {
    if (is.null(data)) {
      NULL
    } else {
      res <- try(
        list(start = as.Date(data$start),
             end = as.Date(data$end)),
        silent = TRUE)
      if ("try-error" %in% class(res)) {
        warning("Failed to parse dates!")
        data
      } else {
        res
      }
    }
  }, force = TRUE)
}
