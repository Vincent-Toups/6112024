library(shiny);
library(tidyverse);
library(plotly);

ui <- shinyUI(fluidPage(
numericInput(inputId="n",value=1,label="Samples"),
plotlyOutput(outputId="thePlot")));

server <- function(input, output) {
    output$thePlot <- renderPlotly(ggplot(tibble(x=rnorm(as.numeric(input$n))),aes(x))
                                 +geom_histogram());
}

# Start the Server
shinyApp(ui=ui,server=server,
  options=list(port=8888, host="0.0.0.0"));

