library(shiny);
library(tidyverse);

ui <- shinyUI(fluidPage(
numericInput(inputId="n",value=1,label="Samples"),
plotOutput(outputId="thePlot")));

server <- function(input, output) {
    output$thePlot <- renderPlot(ggplot(tibble(x=rnorm(as.numeric(input$n))),aes(x))
                                 +geom_histogram());
}

# Start the Server
shinyApp(ui=ui,server=server,
  options=list(port=8080, host="0.0.0.0"));

