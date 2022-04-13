library(shiny)
library(perioddaterangepicker)

ui <- fluidPage(
  perioddaterangepicker(
    inputId = "perioddaterange",
    label = "Pick a Date",
    start = Sys.Date() - 3, end = Sys.Date(),
    max = Sys.Date()+1,
    icon = icon("calendar"),
    language = "de",
    timezone = "utc",
    options = perioddaterangeOptions(
      period = "day",
      periods = NULL,
      firstDayOfWeek = 1,
      single = FALSE,
      orientation = "right",
      opened = TRUE,
      expanded = TRUE,
      standalone = FALSE,
      hideWeekdays = FALSE,
      anchorElement = NULL,
      parentElement = NULL,
      forceUpdate = TRUE,
      locale = list(
        applyButtonTitle = "Bestätigen",
        cancelButtonTitle = "Abbrechen",
        endLabel = "Ende",
        inputFormat = "YY-MM-DD",
        startLabel = "Start"
        ))
  ),
  verbatimTextOutput("print")
)

server <- function(input, output, session) {
  output$print <- renderPrint({
    txt <- req(input$perioddaterange)
    print(txt)
  })
}
shinyApp(ui, server)

