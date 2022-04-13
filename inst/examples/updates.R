library(shiny)
library(daterangepicker)

## UI ##########################
ui <- fluidPage(
  br(),
  tags$head(
    tags$style(".somenewclass {
                  background-color: yellow !important;
                  color: green !important;
                  border-radius: 4px !important;
               }")),
  splitLayout(
    cellWidths = c("30%", "70%"),
    div(
      perioddaterangepicker(
        inputId = "datepicker",
        label = "Pick a Date",
        start = Sys.Date() - 3, end = Sys.Date(),
        max = Sys.Date()+5,
        icon = icon("calendar"),
        ranges = list(
          "Today" = Sys.Date(),
          "Last 3 days" = c(Sys.Date() - 2, Sys.Date()),
          "Last 7 days" = c(Sys.Date() - 6, Sys.Date()),
          "Last 30 days" = c(Sys.Date() - 29, Sys.Date())
        ),
        options = perioddaterangeOptions(
          period = "day",
          periods = c("day","week","month"),
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
            startLabel = "Start",
            dayLabel = "Tag",
            weekLabel = "Woche",
            monthLabel = "Monat",
            quarterLabel = "Quartal",
            yearLabel = "Jahr"
          ))
    )),
    div(
      verbatimTextOutput("print"),
      actionButton("act", "Update Daterangepicker (start/end/min/max/style)"),
      actionButton("class", "Update Daterangepicker (class)"),
      actionButton("options", "Update Daterangepicker (options)")
      # ,actionButton("range", "Update Daterangepicker (ranges)")
    )
  ),
  div(class="newparent",
      "New parent")
)

## SERVER ##########################
server <- function(input, output, session) {
  output$print <- renderPrint({
    req(input$datepicker)
    input$datepicker
  })
  observeEvent(input$class, {
    updatePerioddaterangepicker(session, "datepicker", class = "somenewclass")
  })
  observeEvent(input$act, {
    updatePerioddaterangepicker(
      session, "datepicker",
      start = Sys.Date(), end = Sys.Date() - 5,
      min = Sys.Date()-20,
      max = Sys.Date()+1,
      style = "border-radius:20px;text-align:left;color:red;border-width:1px;",
      label = "A New Label",
      icon = icon("cogs")
    )
  })
  observeEvent(input$options, {
    updatePerioddaterangepicker(session, "datepicker",
                                options = list(
                                  period="week",
                                  hideWeekdays = TRUE,
                                  single = TRUE,
                                  expanded = TRUE,
                                  opened = TRUE,
                                  parentElement = ".newparent",
                                  orientation = "left",
                                  periods = c("day", "week","quarter")))
  })
  # observeEvent(input$range, {
  #   updatePerioddaterangepicker(session, "datepicker",
  #                         ranges = list(
  #                           "Today" = Sys.Date(),
  #                           "Last 5 days" = c(Sys.Date() - 4, Sys.Date()),
  #                           "Last 60 days" = c(Sys.Date() - 60, Sys.Date())
  #                         ))
  # })
}

shinyApp(ui, server)
