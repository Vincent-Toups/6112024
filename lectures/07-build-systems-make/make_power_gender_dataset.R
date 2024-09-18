library(tidyverse);
source("utils.R");

powers <- read_csv("derived_data/deduplicated_powers.csv");

genders <- read_csv("derived_data/gender_data.csv");

power_gender <- genders %>%
    inner_join(powers, by=c("character","universe")) %>%
    select(-url,-property_name) %>%
    rename(gender=value) %>%
    write_csv("derived_data/power_gender_data.csv");

gender_counts <- power_gender %>% group_by(gender) %>% tally(name="total");

probs <- power_gender %>%
    inner_join(gender_counts, by="gender") %>%
    group_by(power, gender, total)  %>% 
    summarize(p=length(character)/total[[1]]) %>%
    arrange(gender,desc(p)) %>%
    group_by(gender) %>%
    mutate(rank=seq(length(p))) %>%
    ungroup() %>%
    write_csv("derived_data/power_gender_ranks.csv");

