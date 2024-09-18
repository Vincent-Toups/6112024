library(tidyverse);
source("utils.R");

args <- commandArgs(trailingOnly=TRUE);

input_sd <- args[[1]];

ensure_directory("logs");

log <- make_logger(sprintf("logs/deduplication_%s.md", input_sd));

df <- read_csv(sprintf("source_data/%s.csv", input_sd));

names(df) <- simplify_strings(names(df)); 

deduplicated <- df %>% mutate(across(everything(), simplify_strings)) %>%
    distinct();
log("Before simplification and deduplication of %s: %d, after %d (%0.2f %% decrease)",
    input_sd,
    nrow(df),
    nrow(deduplicated),
    100-100*nrow(deduplicated)/nrow(df));

ensure_directory("derived_data");
write_csv(deduplicated, sprintf("derived_data/deduplicated_%s.csv", input_sd));

