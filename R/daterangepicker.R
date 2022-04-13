

#' updatePerioddaterangepicker
#'
#' Change the start and end values of a daterangepicker on the client
#'
#' @param session The session object passed to function given to shinyServer.
#' @inheritParams daterangepicker
#' @family daterangepicker Functions
#' @export
updatePerioddaterangepicker <- function(session, inputId, label = NULL,
                                  start = NULL, end = NULL,
                                  min = NULL, max = NULL,
                                  icon = NULL, options = NULL,
                                  ranges = NULL, style = NULL,
                                  class = NULL) {

  ## If no icon was passed initially, we need to create a WebDependency-list
  ## On the JS-side `Shiny.renderDependencies` adds the deps to the header
  if (!is.null(icon)) {
    icon$htmldeps <- list(shiny::createWebDependency(
      htmltools::resolveDependencies(
        htmltools::htmlDependencies(
          icon
        )
      )[[1]]
    ))
  }

  message <- filterEMPTY(list(
    id = session$ns(inputId),
    label = label,
    start = start,
    end = end,
    minDate = min,
    maxDate = max,
    icon = icon,
    options = options,
    ranges = ranges,
    style = style,
    class = class
  ))

  session$sendInputMessage(inputId, message)
}





#' perioddaterangepicker
#'
#' The Date Range Picker pops up two calendars for selecting dates, times, or
#' predefined ranges like "Yesterday", "Last 30 Days", etc.
#'
#' @importFrom shiny restoreInput
#' @importFrom htmltools htmlDependencies<- htmlDependencies htmlDependency tags
#'   tagList
#' @importFrom jsonify to_json
#' @importFrom utils packageVersion
#'
#' @param inputId The input ID
#' @param label The label for the control, or NULL for no label.
#' @param start The beginning date of the initially selected. Must be a Date /
#'   POSIXt or string.
#' @param end The end date of the initially selected date range. Must be a Date
#'   / POSIXt or string.
#' @param min The earliest date a user may select. Must be a Date or string
#' @param max The latest date a user may select. Must be a Date or string
#' @param ranges Set predefined date ranges the user can select from. Each key
#'   is the label for the range, and its value an array with two dates
#'   representing the bounds of the range.
#' @param language The language used for month and day names. Default is "en".
#'   See the \href{https://momentjs.com/}{Multiple Locale Support} for a list of
#'   other valid values.
#' @param timezone Sets the time zone. If you want to use user's computer
#'   time zone, pass \code{NULL}. By default, it's `utc`
#' @param style Add CSS-styles to the input.
#' @param class Custom class
#' @param icon Icon to display next to the label.
#' @param options List of further options. See
#'   \code{\link{perioddaterangeOptions}}
#'
#' @seealso
#' \href{https://sensortower.github.io/daterangepicker/}{https://sensortower.github.io/}
#'
#' @export
#' @family perioddaterangepicker Functions
perioddaterangepicker <- function(
  inputId = NULL,
  label = "Select a Date",
  start = NULL, end = NULL,
  min = NULL, max = NULL,
  ranges = NULL,
  language = "en",
  timezone = "utc",
  style = "width:100%;border-radius:4px;text-align:center;",
  class = NULL,
  icon = NULL,
  options = perioddaterangeOptions()) {

  ## Check Inputs #######################
  if (is.null(inputId)) stop("Perioddaterangepicker needs an `inputId`")
  if (!is.null(start)) start <- as.character(start)
  if (!is.null(end)) end <- as.character(end)
  if (!is.null(min)) min <- as.character(min)
  if (!is.null(max)) max <- as.character(max)
  if (!is.null(ranges)) ranges <- checkRanges(ranges)
  #######################

  ## Enable Bookmarking / Restore #####################
  restored <- restoreInput(id = inputId, default = list(start, end))
  start <- restored[[1]]
  end <- restored[[2]]
  #######################

  ## Fill + Filter options #######################
  options <- filterEMPTY(c(
    list(
      start = start,
      end = end,
      minDate = min, maxDate = max,
      ranges = ranges,
      language = language,
      timeZone = timezone
    ), options))
  #######################

  ## Make Input Tag #######################
  x <- makeInput(label, inputId, class, icon, style, options)
  #######################

  ## Attach dependencies and output ###################
  htmlDependencies(x) <- htmlDependency(
    name = "perioddaterangepicker",
    version = packageVersion("perioddaterangepicker"),
    src = system.file("htmlwidgets", package = "perioddaterangepicker"),
    script = c(
      ifelse(is.null(language), "moment/moment.min.js", "moment/moment.locales.min.js"),
      "perioddaterangepicker/knockout.js",
      "perioddaterangepicker/daterangepicker.js",
      "perioddaterangepicker-bindings.js"
    ),
    stylesheet = "perioddaterangepicker/daterangepicker.min.css"
  )
  #######################
  x
}


#' perioddaterangeOptions
#'
#' Update the perioddaterangepicker
#'
#' @param period This parameter sets the initial value for period. Must be one
#'   of \code{c('day','week','month','quarter','year')}
#' @param periods Array of available periods. Period selector disappears if
#'   only one period specified.
#' @param firstDayOfWeek Sets first day of the week. 0 is Sunday, 1 is Monday.
#'   In case you were wondering, 4 is Thursday.
#' @param single Should only a single date be selected. Default is \code{FALSE}
#' @param orientation Sets the side to which daterangepicker opens. Must be one
#'   of \code{c('left','right')}.
#' @param opened By default, daterangepicker is hidden and you need to click the
#'   \code{anchorElement} to open it. This option allows you to make it opened
#'   on initialization. Default is \code{FALSE}
#' @param expanded By default, when you open daterangepicker you only see
#'   predefined ranges. This option allows you to make it expanded on
#'   initialization. Default is \code{FALSE}
#' @param standalone Set standalone to true to append daterangepicker to
#'   \code{anchorElement}. Default is \code{FALSE}
#' @param hideWeekdays Set to \code{TRUE} to hide week days in day & week modes.
#' @param anchorElement Allows you to set anchor element for daterangepicker.
#' @param parentElement Allows you to set parent element for daterangepicker.
#' @param forceUpdate Immediately invokes callback after constructing
#'   daterangepicker.
#' @param locale A list with the Date format and Button labels.
#'
#' @seealso
#' \href{https://sensortower.github.io/daterangepicker/docs}{https://sensortower.github.io/}
#'
#' @family perioddaterangepicker Functions
#' @export
perioddaterangeOptions <- function(period = c("day","week","month","quarter","year"),
                                   periods = NULL,
                                   firstDayOfWeek = 0,
                                   single = FALSE,
                                   orientation = c("right", "left"),
                                   opened = FALSE,
                                   expanded = FALSE,
                                   standalone = FALSE,
                                   hideWeekdays = FALSE,
                                   anchorElement = NULL,
                                   parentElement = NULL,
                                   forceUpdate = FALSE,
                                   locale = list(
                                     applyButtonTitle = "Apply",
                                     cancelButtonTitle = "Cancel",
                                     endLabel = "End",
                                     inputFormat = "L",
                                     startLabel = "Start",
                                     dayLabel = "Day",
                                     weekLabel = "Week",
                                     monthLabel = "Month",
                                     quarterLabel = "Quarter",
                                     yearLabel = "Year")
                                   ) {

  ## Check Inputs ###################
  period <- match.arg(period)
  orientation <- match.arg(orientation)
  if (!is.null(locale)) {
    locale <- as.list(iconv(unlist(locale), to="UTF-8"))
  }

  ## Filter and create options-List #########################
  filterEMPTY(list(
    period = period,
    periods = periods,
    firstDayOfWeek = firstDayOfWeek,
    single = single,
    orientation = orientation,
    opened = opened,
    expanded = expanded,
    standalone = standalone,
    hideWeekdays = hideWeekdays,
    anchorElement = anchorElement,
    parentElement = parentElement,
    forceUpdate = forceUpdate,
    locale = locale
  ))
}

