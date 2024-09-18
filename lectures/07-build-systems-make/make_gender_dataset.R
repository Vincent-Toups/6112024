library(tidyverse);
source("utils.R");

good_values = str_split("intersex non_binary genderless female male", " ", simplify=TRUE);

data <- read_csv("derived_data/deduplicated_character-data.csv") %>%
    filter(property_name=="gender") %>%
    filter(value %in% good_values) %>%
    mutate(value={
        value[value=="genderless"] <- "male";
        value
    }) %>%
    write_csv("derived_data/gender_data.csv");


