library(shiny);
library(tidyverse);
library(plotly);

pows <- read_csv("derived_data/character_powers.csv");
powers <- pows$name %>% unique();
pows <- pows %>% filter(value==1);

chars <- read_csv("derived_data/character_properties.csv");
props <- chars$name %>% unique();

interesting_properties <- c("affiliation",
                            "alignment",
                            "citizenship",
                            "marital_status",
                            "occupation",
                            "gender",
                            "eyes",
                            "hair",
                            "creators",
                            "base_of_operations",
                            "skin",
                            "race",
                            "status");

chars <- chars %>% filter(value!="!missing!");

property_counts <- chars %>% group_by(name, value) %>% tally()

chars <- chars %>% inner_join(property_counts, by=c("name","value")) %>%
  group_by(n<70) %>% mutate(value=ifelse(n<70,"other",value)) %>% ungroup() %>%
  select(-n);


ggplot(property_counts %>% filter(n<exp(2.5)),aes(n)) + geom_density()

emb <- read_csv("derived_data/character_embedding.csv");

ui <- shinyUI(fluidPage(
    titlePanel("Comic Character Explorer"),
    sidebarLayout(sidebarPanel(selectizeInput(inputId="power",
                                              label="Power",
                                              choices=powers,
                                              multiple=F),
                               selectizeInput(inputId="property",
                                              label="Property",
                                              choices=interesting_properties,
                                              multiple=F)),
                  mainPanel(plotlyOutput("graph")))
));

server <- function(input, output) {
    output$graph <- renderPlotly({

        power <- input$power;
        property <- input$property;

        power_ss <- pows %>% filter(name==power);
        
        chars_ss <- chars %>%
            filter(name==property) %>%
            group_by(character) %>%
            filter(row_number()==1) %>%
            ungroup();
            

        emb_ex <- emb %>% left_join(chars_ss, by="character");
        
        plt <- ggplot(emb_ex, aes(x, y, text=character)) +
            geom_point(aes(size=c("TRUE"=1,"FALSE"=0.5)[(character %in% power_ss$character) %>% as.character()],
                           color=factor(value))) +
            labs(size="Has Power",
                 color="Property");
        ggplotly(plt, tooltip="text");
    });
}

# Start the Server
shinyApp(ui=ui,server=server,
  options=list(port=8080, host="0.0.0.0"));

