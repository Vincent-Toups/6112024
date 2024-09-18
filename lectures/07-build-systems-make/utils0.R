library(tidyverse); 

simplify_strings <- function(s){
    s <- str_to_lower(s);
    s <- str_trim(s);
    s <- str_replace_all(s,"[^a-z]+","_")
    s
}

ensure_directory <- function(directory){
    if(!dir.exists(directory)){
        dir.create(directory);
    }
}
