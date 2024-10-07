library(tidyverse)

data <- rbind(tibble(q=rnorm(10000, 3, 1),
                     r=rnorm(10000, 3, 1)),
              tibble(q=rnorm(10000, -3, 1),
                     r=rnorm(10000, 3, 1)),
              tibble(q=rnorm(10000, 0, 1),
                     r=rnorm(10000, -3, 1))) %>% sample_n(nrow(.),replace=F);

cc <- kmeans(data,centers=3);
data$cluster <- cc$cluster;

ggplot(data, aes(q,r)) +
    geom_point(aes(color=factor(cluster)), alpha=0.1);


              



