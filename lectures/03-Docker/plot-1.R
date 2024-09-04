library(tidyverse)

d <- read_csv("./data/powers.csv") %>% 
  filter(universe=="New Earth") %>% select(-universe, -url); 
alignment <- read_csv("./data/character-data.csv") %>%
  filter(universe=="New Earth" & property_name == "Alignment") %>%
  select(-universe, -property_name) %>%
  rename(alignment=value);

alignment <- rbind(alignment %>% filter(alignment=="Good") %>% sample_n(1000),
                   alignment %>% filter(alignment=="Bad") %>% sample_n(1000),
                   alignment %>% filter(alignment=="Neutral") %>% sample_n(1000));

power_tally <- d %>% group_by(power) %>% tally() %>% arrange(desc(n));


common_powers <- d %>% filter(power %in% head(power_tally,10)[["power"]]) %>%
  left_join(alignment, by="character") %>%
  mutate(power=factor(power, power_tally[["power"]])) %>% 
  filter(alignment %in% c("Good","Bad","Neutral"));

p <- ggplot(common_powers, aes(power)) + 
  geom_histogram(stat="count",position="dodge2",aes(fill=alignment)) + 
  theme(axis.text.x = element_text(angle = 90))
print(p)

library(matlab);
wider_data <- pivot_wider(d %>% mutate(dummy=T),
                          character,
                          names_from = power,
                          values_from = dummy,
                          values_fill = F);
vectors <- wider_data %>%
  select(-character) %>%
  as.matrix() %>%
  `*`(1.0);
imagesc(vectors);

write_csv(wider_data, "powers_wider.csv", row.names=F);

