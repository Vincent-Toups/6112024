library(tidyverse);
source("utils.R");
info <- read_csv("./source_data/datasets_26532_33799_heroes_information.csv") %>%
    drop_na() %>% 
    nice_names() %>%
    mutate(female=gender=='Female',
           train=runif(nrow(.))<0.75,
           hair_color = factor(hair_color) ,
           hair_blond = hair_color == "Blond") %>%
    filter(height > 0 & weight > 0);

hair_table <- table(info$hair_color);

info <- info %>% mutate(hair_color_simplified=hair_color) %>%
    mutate(hair_color_simplified=(function(hcs){
        hcs[hair_table[hcs]<10] = "Other";
        hcs
    })(hair_color_simplified));

