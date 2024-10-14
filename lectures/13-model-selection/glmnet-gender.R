library(glmnet)
library(tidyverse);
hero_stats <- read_csv("source_data/datasets_38396_60978_charcters_stats.csv") %>%
    filter(Total > 5) %>% filter(complete.cases(.)) %>% inner_join(read_csv("source_data/datasets_26532_33799_heroes_information.csv") %>%
                                                                  select(-Alignment),by="Name");

center_scale <- function(x){
  maxv <- max(x);
  minv <- min(x);
  range <- maxv-minv;
  (x-minv)/range - 0.5;
}
hero_stats <- hero_stats %>% mutate(across(Intelligence:Total, center_scale)) %>%
    mutate(train=runif(nrow(.))<0.75) %>% filter(Gender %in% c("Female","Male"))%>%
    mutate(Gender=1*(Gender=="Male"));

hero_stats_train <- hero_stats %>% filter(train) %>% select(-train);
hero_stats_test <- hero_stats %>% filter(!train) %>% select(-train);


results <- cv.glmnet(hero_stats_train %>% select(Intelligence:Combat) %>% as.matrix(),
                    hero_stats_train$Gender,
                    alpha=1,
                    family="binomial");

plot(results)
best_model <- glmnet(hero_stats_train %>% select(Intelligence:Combat) %>% as.matrix(),
                    hero_stats_train$Gender,
                    alpha=1,
                    family="binomial",
                    lambda=results$lambda.min);

coef(best_model);
names(best_model)
hero_stats_test$gender_predicted_p <- (predict(best_model, hero_stats_test %>% select(Intelligence:Combat) %>% as.matrix(), type="response"))*1;
hero_stats_test$gender_predicted <- (predict(best_model, hero_stats_test %>% select(Intelligence:Combat) %>% as.matrix(), type="response") > 0.7)*1;
confusion <- hero_stats_test %>% group_by(Gender, gender_predicted) %>% tally()

assess.glmnet(best_model, newy=hero_stats_test$Gender, newx=hero_stats_test %>% select(Intelligence:Combat) %>% as.matrix());

