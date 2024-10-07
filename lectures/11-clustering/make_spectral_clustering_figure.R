library(tidyverse)

shannon <- function(sequence){
  tbl <- (table(sequence)/length(sequence)) %>% as.numeric();
  -sum(tbl*log2(tbl))
}

mutinf <- function(a,b){
  sa <- shannon(a);
  sb <- shannon(b);
  sab <- shannon(sprintf("%d:%d", a, b));
  sa + sb - sab;
}

normalized_mutinf <- function(a,b){
  2*mutinf(a,b)/(shannon(a)+shannon(b));
}

voltages_wide <- read_csv("source_data/voltages_wide.csv")
sc_labels <- read_csv("spectral_clustering_labels.csv");
voltages_wide$sc_label <- sc_labels$labels;
normalized_mutinf(voltages_wide$label, voltages_wide$sc_label)
data$cluster <- sc_labels;
p <- ggplot(data, aes(x,y)) + geom_point(aes(color=cluster));
ggsave("spectral_clustering_figure.png",plot=p)