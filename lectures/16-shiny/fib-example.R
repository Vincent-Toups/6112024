library(shiny);

ui <- fluidPage(
    numericInput(inputId="n",value=1,label="n"),
    textOutput(outputId="nthValue"),
    textOutput(outputId="nthValueInv"));

fib <- function(n) ifelse(n<3, 1, fib(n-1)+fib(n-2))

server <- function(input, output) {
  currentFib         <- reactive({ fib(as.numeric(input$n)) })

  output$nthValue    <- renderText({ currentFib() })
  output$nthValueInv <- renderText({ 1 / currentFib() })
}

# Start the Server
shinyApp(ui=ui,server=server,
  options=list(port=8888, host="0.0.0.0"));

