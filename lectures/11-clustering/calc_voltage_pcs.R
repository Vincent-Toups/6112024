library(tidyverse);
library(rdist);

voltages_wide <- read_csv("./source_data/voltages_wide.csv");

pca.r <- prcomp(voltages_wide %>% select(-trial,-label,-`0`), scale=T, center=T)$x %>% as_tibble();
pca.r$label <- voltages_wide$label;
s <- pca.r;
ld <- s %>% as_tibble() %>% select(PC1, PC2);
write_csv(ld, "pca_voltage_project.csv")
