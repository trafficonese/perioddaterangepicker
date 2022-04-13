#' filterEMPTY
#' Filter empty elements of a list
#' @param x The list of values
filterEMPTY <- function(x) {
  x[!lengths(x) == 0]
}

#' checkRanges
#' Check the ranges element, for Date or POSIX objects
#' @param ranges The list of ranges
checkRanges <- function(ranges) {
  cls <- lapply(ranges, class)
  if (!all(unlist(cls) %in% c("Date","POSIXct","POSIXt","POSIXlt"))) {
    stop("All elements of `ranges` must be of class:\n",
         "`Date`, `POSIXct`, `POSIXlt` or `POSIXt`.")
  } else {
    # ranges <- lapply(ranges, as.POSIXct, origin = "1970-01-01")
    ranges <- lapply(ranges, as.character)
  }
  ranges
}

#' makeInput
#' Make the input div-tag
#' @param label The label of the perioddaterangepicker
#' @param inputId The inputId of the perioddaterangepicker
#' @param class The class of the perioddaterangepicker
#' @param icon The icon of the perioddaterangepicker
#' @param style The style of the perioddaterangepicker
#' @param options The options of the perioddaterangepicker
makeInput <- function(label, inputId, class, icon, style, options) {
  tags$div(
    class = "form-group shiny-input-container",
    makeLabel(label, inputId),
    icon,
    tags$input(
      id = inputId,
      class = paste("perioddaterangepickerclass", class),
      name = "perioddaterangepicker",
      type = "text",
      style = style,
      options = jsonify::to_json(options, unbox = TRUE)
    )
  )
}


#' makeLabel
#' Make the label
#' @param label The label of the daterangepicker
#' @param inputId The inputId of the daterangepicker
makeLabel <- function(label, inputId) {
  if (is.null(label)) {
    NULL
  } else {
    tags$label(label, class = "control-label", `for` = inputId)
  }
}
