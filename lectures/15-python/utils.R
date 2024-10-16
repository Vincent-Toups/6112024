library(tidyverse);

nice_names <- function(df){
    names(df) <- names(df) %>% str_replace_all("[^a-zA-Z0-9]+","_") %>%
        str_replace_all("[_]+$","") %>%
        str_replace_all("^[_]+","") %>%
        tolower();
    df
};

add_other <- function(df, column, thresh){
    tbl <- df[[column]] %>% table() %>% `/`(nrow(df));
    the_c <- df[[column]];
    the_c[tbl[the_c]<thresh] <- "other";
    df[[column]] <- the_c;
    df
}

`%without%` <- function(s1,s2){
    s1[!(s1 %in% s2)];
}

chars_to_factors <- function(df){
    for(n in names(df)){
        if(typeof(df[[n]]) == typeof('')){
            df[[n]] <- factor(df[[n]]);
        }
    }
    df;
}
