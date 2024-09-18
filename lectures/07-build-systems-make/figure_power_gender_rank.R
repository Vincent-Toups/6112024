library(tidyverse);
library(ggplot2);
source("utils.R")

gender_to_x <- function(g){
    x=c("male"=1,"female"=-1)
    x[g];
}



ranked_gendered <- read_csv("derived_data/power_gender_ranks.csv");

ranked_gendered <- ranked_gendered %>% filter(rank<=20) %>% select(-p,-total);

power_order <- ranked_gendered %>% group_by(power) %>% summarize(mr = mean(rank)) %>%
    arrange(mr) %>% `[[`("power")

ranked_gendered$power <- factor(ranked_gendered$power,power_order);

male <- ranked_gendered %>% filter(gender=="male") %>%
    rename(male_rank=rank);
female <- ranked_gendered %>% filter(gender=="female") %>%
    rename(female_rank=rank);

line_data_male <- male %>% left_join(female, by="power") %>%
    select(-gender.x, -gender.y);
line_data_female <- male %>% right_join(female, by="power") %>%
    select(-gender.x, -gender.y);

line_data <- rbind(line_data_male, line_data_female) %>% distinct() %>%
    mutate(male_rank=replace_na(male_rank,21),
           female_rank=replace_na(female_rank,21));

the_plot <- ggplot(ranked_gendered) +
    geom_rect(aes(xmin=gender_to_x(gender)-0.5,
              xmax=gender_to_x(gender)+0.5,
              ymin=rank-0.45,
              ymax=rank+0.45,
              fill=power),
              show.legend = FALSE) +
    geom_text(aes(x=gender_to_x(gender),
                  y=rank,
                  label=power)) +
    geom_segment(data=line_data,aes(x=-0.5,xend=0.5,
                            y=female_rank,
                            yend=male_rank,
                            color=power),
                 show.legend = FALSE) +
    ylim(0,21) +
    scale_y_reverse(breaks = 1:20) +
    scale_x_continuous(breaks=c(-1,1),
                       labels=c("Female","Male")) + 
    labs(x="Sex Presentation",y="Rank", title="Are superpowers distributed differently by presented sex?");

ensure_directory("figures");

ggsave("figures/power_gender_rank.png", the_plot);
