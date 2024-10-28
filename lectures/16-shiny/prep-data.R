library(tidyverse);
library(reticulate);
use_python("/usr/bin/python3");

manifold <- import("sklearn.manifold");

chars <- read_csv("source_data/characters.csv") %>%
    select(-universe) %>% distinct() %>%
    group_by(character, property_name, value) %>%
    tally() %>%
    group_by(character, property_name) %>%
    arrange(desc(n)) %>%
    filter(row_number()==1) %>%
    ungroup();

pows <- read_csv("source_data/powers.csv") %>%
    select(-universe,-url) %>% distinct();

chars_w <- chars %>% pivot_wider(id_cols="character", names_from="property_name", values_from="value",
                                 values_fn=function(...){
                                     paste(list(...) %>% unlist(),
                                           collapse=",");
                                 },
                                 values_fill=list(value="!missing!"));

pows_w <- pows %>% pivot_wider(id_cols="character",
                               names_from="power",
                               values_from="power",
                               values_fn=function(v){
                                   if(is.na(v)){
                                       0
                                   } else {
                                       1
                                   }
                               },values_fill=list(power=0));

pows_m <- pows_w %>% select(-character) %>% as.matrix();


do_tsne <- function(m){
    instance <- manifold$TSNE(n_components=as.integer(2));
    instance$fit_transform(m) %>% as_tibble();
}

simplify_column <- function(values){
    tbl <- table(values);
}

embedding <- do_tsne(pows_m);

if(!dir.exists("derived_data")){
    dir.create("derived_data");
}

pows_w %>% transmute(character=character,
                     x=embedding$V1,
                     y=embedding$V2) %>%
    write_csv("derived_data/character_embedding.csv");

chars_w %>% filter(character %in% pows_w$character) %>%
    pivot_longer(-character) %>%
    write_csv("derived_data/character_properties.csv");

pows_w %>% pivot_longer(-character) %>%
    write_csv("derived_data/character_powers.csv");




