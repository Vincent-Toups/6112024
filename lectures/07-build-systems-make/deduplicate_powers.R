library(tidyverse);
source("utils.R");

df <- read_csv("source_data/powers.csv");

names(df) <- simplify_strings(names(df)); 

deduplicated <- df %>% mutate(across(everything(), simplify_strings)) %>%
    distinct();
print(sprintf("Before simplification and deduplication: %d, after %d (%0.2f %% decrease)",
              nrow(df),
              nrow(deduplicated),
              100-100*nrow(deduplicated)/nrow(df)));

ensure_directory("derived_data");
write_csv(deduplicated, "derived_data/deduplicated-powers.csv");

