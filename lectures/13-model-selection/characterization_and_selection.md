Model Characterization and Selection
========================================================
author: Vincent Toups
date: 11 Sept 2020
width:1400
height:800
css:style.css

![](./images/800px-Carrots_of_many_colors.jpg)

Suppose you train a model:
==========================




```r
info
```

```
# A tibble: 489 x 15
      x1 name  gender eye_color race  hair_color height publisher skin_color
   <dbl> <chr> <chr>  <chr>     <chr> <chr>       <dbl> <chr>     <chr>     
 1     0 A-Bo… Male   yellow    Human No Hair       203 Marvel C… -         
 2     1 Abe … Male   blue      Icth… No Hair       191 Dark Hor… blue      
 3     2 Abin… Male   blue      Unga… No Hair       185 DC Comics red       
 4     3 Abom… Male   green     Huma… No Hair       203 Marvel C… -         
 5     5 Abso… Male   blue      Human No Hair       193 Marvel C… -         
 6     7 Adam… Male   blue      Human Blond         185 DC Comics -         
 7     8 Agen… Female blue      -     Blond         173 Marvel C… -         
 8     9 Agen… Male   brown     Human Brown         178 Marvel C… -         
 9    10 Agen… Male   -         -     -             191 Marvel C… -         
10    11 Air-… Male   blue      -     White         188 Marvel C… -         
# … with 479 more rows, and 6 more variables: alignment <chr>, weight <dbl>,
#   female <lgl>, train <lgl>, hair_blond <lgl>, hair_color_simplified <fct>
```


```r
model.glm <- glm(female ~ height + weight + I(height^2) + I(weight^2) + height:weight + hair_color_simplified, info %>% filter(train), family="binomial");
summary(model.glm);
```

```

Call:
glm(formula = female ~ height + weight + I(height^2) + I(weight^2) + 
    height:weight + hair_color_simplified, family = "binomial", 
    data = info %>% filter(train))

Deviance Residuals: 
   Min      1Q  Median      3Q     Max  
 -8.49    0.00    0.00    0.00    8.49  

Coefficients:
                               Estimate Std. Error   z value Pr(>|z|)    
(Intercept)                  -8.336e+14  6.648e+07 -12539165   <2e-16 ***
height                        4.349e+12  4.478e+05   9713287   <2e-16 ***
weight                       -1.315e+13  1.735e+05 -75745972   <2e-16 ***
I(height^2)                  -1.273e+10  4.590e+02 -27724715   <2e-16 ***
I(weight^2)                   3.341e+10  2.191e+02 152460154   <2e-16 ***
hair_color_simplifiedAuburn  -5.971e+14  3.176e+07 -18798967   <2e-16 ***
hair_color_simplifiedBlack    1.512e+15  2.080e+07  72706379   <2e-16 ***
hair_color_simplifiedBlond    2.225e+15  2.197e+07 101242647   <2e-16 ***
hair_color_simplifiedBrown    1.855e+15  2.151e+07  86230091   <2e-16 ***
hair_color_simplifiedNo Hair  1.031e+15  2.312e+07  44578225   <2e-16 ***
hair_color_simplifiedOther    1.995e+15  2.411e+07  82726015   <2e-16 ***
hair_color_simplifiedRed      4.190e+15  2.503e+07 167374551   <2e-16 ***
hair_color_simplifiedWhite    2.837e+15  2.745e+07 103346216   <2e-16 ***
height:weight                -4.980e+10  7.859e+02 -63365673   <2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

(Dispersion parameter for binomial family taken to be 1)

    Null deviance:  276.92  on 240  degrees of freedom
Residual deviance: 4253.15  on 227  degrees of freedom
AIC: 4281.2

Number of Fisher Scoring iterations: 25
```

***


```r
test <- info %>% filter(!train);
test$female.p <- predict(model.glm, test, type="response");
ggplot(test, aes(female.p)) + geom_density();
```

![plot of chunk unnamed-chunk-4](characterization_and_selection-figure/unnamed-chunk-4-1.png)


```r
c(sum((test$female.p>0.5)==test$female)/nrow(test),sum(FALSE==test$female)/nrow(test));
```

```
[1] 0.7177419 0.6854839
```

Suppose you train a model:
==========================


```r
library(gbm);
model.gbm <- gbm(female ~ height +
                     weight +
                     I(height^2) +
                     I(weight^2) +
                     height:weight +
                     hair_color_simplified,
                 distribution="bernoulli",
                 info %>% filter(train),
                 n.trees = 200,
                 interaction.depth = 5,
                 shrinkage=0.1);
summary(model.gbm,plot=FALSE)
```

```
                                        var  rel.inf
weight                               weight 54.11079
hair_color_simplified hair_color_simplified 29.17432
height                               height 16.71489
I(height^2)                     I(height^2)  0.00000
I(weight^2)                     I(weight^2)  0.00000
height:weight                 height:weight  0.00000
```

***

![plot of chunk unnamed-chunk-7](characterization_and_selection-figure/unnamed-chunk-7-1.png)


```r
c(sum((test$female.p.gbm>0.5)==test$female)/nrow(test),
  sum((test$female.p>0.5)==test$female)/nrow(test),
  sum(FALSE==test$female)/nrow(test));
```

```
[1] 0.8709677 0.7177419 0.6854839
```

Which Model is Better?
======================


```r
c(sum((test$female.p.gbm>0.5)==test$female)/nrow(test),
  sum((test$female.p>0.5)==test$female)/nrow(test),
  sum(FALSE==test$female)/nrow(test));
```

```
[1] 0.8709677 0.7177419 0.6854839
```

This is an ill-posed question so far - each of the numbers above
depends on the random process of splitting our data set into test and
train sets.

What is the expected value of some model characterization parameter in
the limit of infinite data? What about variation?

Model Selection
===============

This is "model selection." It would be trivial if we had access to an
infinite amount of data (of course, in that case, we'd just train a
neural network or tree based model). But when you have a limited
amount of data it presents challenges.

K-Fold Cross Validation
=======================

1. Take K "folds".
2. set aside 1 of them for testing
3. collect model performance

![](./images/cross-validation.png)
By Gufosowa - Own work, CC BY-SA 4.0, https://commons.wikimedia.org/w/index.php?curid=82298768

Bootstrapping
=============

Sample from the data with replacement and repeat the modelling process
many times.

By Hand
=======


```r
k_folds <- function(k, data, trainf, statf){
    n <- nrow(data);
    fold_id <- sample(1:k, n, replace=TRUE);
    do.call(rbind, Map(function(fold){
        train <- data %>% filter(fold != fold_id);
        test <- data %>% filter(fold == fold_id);
        model <- trainf(train);
        stat <- statf(model, test);
        tibble(fold=fold, stat=stat);
    },1:k));
}
```

Usage
=====


```r
library(gbm);
n_folds <- 50;
form <- female ~ height +
                     weight +
                     I(height^2) +
                     I(weight^2) +
                     height:weight +
                     hair_color_simplified;
res.glm <- k_folds(n_folds,info,
               function(data){
                   glm(form, data, family="binomial");
               },
               function(model, data){
                   p <- predict(model, data, type="response");
                   sum((p>0.5) == data$female)/nrow(data);
               }) %>% mutate(model="glm");
res.gbm <- k_folds(n_folds,info,
               function(data){
                   gbm(female ~ height +
                     weight +
                     I(height^2) +
                     I(weight^2) +
                     height:weight +
                     hair_color_simplified,
                 distribution="bernoulli",
                 data,
                 n.trees = 200,
                 interaction.depth = 5,
                 shrinkage=0.1);
               },
               function(model, data){
                   p <- predict(model, data, type="response", n.trees=200);
                   sum((p>0.5) == data$female)/nrow(data);
               }) %>% mutate(model="gbm");
res.dumb <- k_folds(n_folds,info,
               function(data){
                   NULL;
               },
               function(model, data){
                   sum(FALSE == data$female)/nrow(data);
               }) %>% mutate(model="dumb");
res <- rbind(res.glm, res.gbm, res.dumb);
```
***
![plot of chunk unnamed-chunk-12](characterization_and_selection-figure/unnamed-chunk-12-1.png)
Might be worth the simpler story to use the GLM in this case.

Selection vs Characterization
=============================

So far we've conflated characterization with selection. They are
related, obviously: we want to select the best (characterized) model.

But when we get into the world of R packages, they tend to be
separated.

Enter The Caret
===============

Caret is a package for characterization and tuning.

http://topepo.github.io/caret/index.html

1. It will help you tune parameters of a given model type.
2. It is not as useful for selecting between various models (either
   types or input parameters). It can help you characterize.
   
Caret Example
=============


```r
library(caret);

trainIndex <- createDataPartition(info$female, p = .8, 
                                  list = FALSE, 
                                  times = 1)

info$female <- factor(info$female);

train_ctrl <- trainControl(method = "cv", number = 50);
gbmFit1 <- train(form, data = info %>% slice(trainIndex), 
                 method = "gbm", 
                 trControl = train_ctrl,
                 ## This last option is actually one
                 ## for gbm() that passes through
                 verbose = FALSE)
summary(gbmFit1);
```

![plot of chunk unnamed-chunk-13](characterization_and_selection-figure/unnamed-chunk-13-1.png)

```
                                                      var    rel.inf
weight                                             weight 38.8216906
height:weight                               height:weight 36.4444174
height                                             height 19.0417523
hair_color_simplifiedRed         hair_color_simplifiedRed  2.8427727
hair_color_simplifiedBlond     hair_color_simplifiedBlond  1.6744723
hair_color_simplifiedBrown     hair_color_simplifiedBrown  0.9092115
hair_color_simplifiedBlack     hair_color_simplifiedBlack  0.2656832
I(height^2)                                   I(height^2)  0.0000000
I(weight^2)                                   I(weight^2)  0.0000000
hair_color_simplifiedAuburn   hair_color_simplifiedAuburn  0.0000000
hair_color_simplifiedNo Hair hair_color_simplifiedNo Hair  0.0000000
hair_color_simplifiedOther     hair_color_simplifiedOther  0.0000000
hair_color_simplifiedWhite     hair_color_simplifiedWhite  0.0000000
```
***

```r
gbmFit1
```

```
Stochastic Gradient Boosting 

392 samples
  3 predictor
  2 classes: 'FALSE', 'TRUE' 

No pre-processing
Resampling: Cross-Validated (50 fold) 
Summary of sample sizes: 385, 384, 384, 384, 384, 385, ... 
Resampling results across tuning parameters:

  interaction.depth  n.trees  Accuracy   Kappa    
  1                   50      0.8575397  0.6467205
  1                  100      0.8657540  0.6602151
  1                  150      0.8751984  0.6816530
  2                   50      0.8606746  0.6510420
  2                  100      0.8576190  0.6305167
  2                  150      0.8663889  0.6503906
  3                   50      0.8553968  0.6275496
  3                  100      0.8701190  0.6730368
  3                  150      0.8680556  0.6565731

Tuning parameter 'shrinkage' was held constant at a value of 0.1

Tuning parameter 'n.minobsinnode' was held constant at a value of 10
Accuracy was used to select the optimal model using the largest value.
The final values used for the model were n.trees = 150, interaction.depth =
 1, shrinkage = 0.1 and n.minobsinnode = 10.
```

Caret Example GLM
=================


```r
library(caret);

trainIndex <- createDataPartition(info$female, p = .8, 
                                  list = FALSE, 
                                  times = 1)

train_ctrl <- trainControl(method = "cv", number = 50);
glmFit1 <- train(form, data = info %>% slice(trainIndex), 
                 method = "glm",
                 family = "binomial",
                 trControl = train_ctrl)
summary(glmFit1);
```

```

Call:
NULL

Deviance Residuals: 
    Min       1Q   Median       3Q      Max  
-1.5278  -0.8631  -0.4346   0.9231   4.0580  

Coefficients:
                                 Estimate Std. Error z value Pr(>|z|)    
(Intercept)                    -1.829e+00  2.451e+00  -0.746 0.455524    
height                          1.618e-02  3.020e-02   0.536 0.592034    
weight                         -1.714e-02  5.404e-03  -3.172 0.001515 ** 
`I(height^2)`                  -4.687e-05  1.116e-04  -0.420 0.674507    
`I(weight^2)`                   3.001e-05  8.778e-06   3.419 0.000629 ***
hair_color_simplifiedAuburn     1.654e+00  1.212e+00   1.365 0.172214    
hair_color_simplifiedBlack      1.373e+00  1.080e+00   1.271 0.203870    
hair_color_simplifiedBlond      1.907e+00  1.085e+00   1.757 0.078922 .  
hair_color_simplifiedBrown      4.475e-01  1.127e+00   0.397 0.691268    
`hair_color_simplifiedNo Hair` -9.630e-01  1.466e+00  -0.657 0.511298    
hair_color_simplifiedOther      1.510e+00  1.125e+00   1.343 0.179431    
hair_color_simplifiedRed        2.383e+00  1.113e+00   2.141 0.032269 *  
hair_color_simplifiedWhite      1.169e+00  1.201e+00   0.973 0.330699    
`height:weight`                -3.645e-05  3.049e-05  -1.196 0.231883    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

(Dispersion parameter for binomial family taken to be 1)

    Null deviance: 470.86  on 391  degrees of freedom
Residual deviance: 383.30  on 378  degrees of freedom
AIC: 411.3

Number of Fisher Scoring iterations: 10
```
***

```r
glmFit1
```

```
Generalized Linear Model 

392 samples
  3 predictor
  2 classes: 'FALSE', 'TRUE' 

No pre-processing
Resampling: Cross-Validated (50 fold) 
Summary of sample sizes: 384, 384, 383, 385, 384, 383, ... 
Resampling results:

  Accuracy   Kappa   
  0.7646825  0.305572
```

Kappa
=====

$$
\kappa = \frac{2 \times (TP \times TN - FN \times FP)}{(TP + FP) \times (FP + TN) + (TP + FN) \times (FN + TN)}
$$

"Cohen's kappa measures the agreement between two raters who each classify N items into C mutually exclusive categories...  If the raters are in complete agreement then κ = 1. If there is no agreement among the raters other than what would be expected by chance (as given by pe), κ = 0. It is possible for the statistic to be negative which implies that there is no effective agreement between the two raters or the agreement is worse than random."

[Cohen's kappa Wikipedia Article](https://en.wikipedia.org/wiki/Cohen%27s_kappa)

Supported Model Types
=====================

Caret supports a large variety of models beyond GLMs and GBMs. See [the
docs](https://topepo.github.io/caret/index.html).

We've just scratched the surface here.

Model (Parameter) Selection
===========================

A related problem here is what pieces of data we use as predictors in
our model. This is a form of model selection as well.

Caret supports various methods for feature selection. We'll
demonstrate recursive feature elimination:

![](./images/rfe-Algo2.png)

Via Caret
=========

This turns out to be broken for lmFuncs
```

rfe_ctrl <- rfeControl(functions = lmFuncs, method = "repeatedcv", repeats = 5, verbose = TRUE);

for (nm in names(info)){
    if(is.character(info[[nm]])){
        info[[nm]] <- factor(info[[nm]]);
    }
}

results <- rfe(info %>% slice(trainIndex) %>%
               select(height, weight, hair_color_simplified, alignment) %>% as.data.frame(),
               info %>% slice(trainIndex) %>%
               mutate(female=as.logical(female)*1) %>%
               select(female) %>%               
               `[[`("female"),
               rfeControl=rfe_ctrl);
summary(results);
```

Doing it Ourselves
==================

Pre-treatment:


```r
library(tidyverse);
source("utils.R");
info <- read_csv("./source_data/datasets_26532_33799_heroes_information.csv") %>%
    drop_na() %>% 
    nice_names() %>%
    mutate(female=gender=='Female',
           train=runif(nrow(.))<0.5,
           hair_color = hair_color) %>%
    filter(height > 0 & weight > 0) %>%
    select(-name);
other_rare_elements <- function(values, thresh){
    tbl <- table(values)/length(values);
    values[tbl[values]<thresh] <- "other";
    values;
}
for (nm in names(info)){
    if(is.character(info[[nm]])){
        info[[nm]] <- factor(paste(":",other_rare_elements(info[[nm]],0.2),sep=""));
    }
}
```

The iteration:
==============



```
library(stringr);
colums_of_interest <- c("height","weight","eye_color","skin_color","publisher");
trainIndex <- createDataPartition(info$female, p = .8, 
                                  list = FALSE, 
                                  times = 1)
info$female <- factor(info$female);
extract_var_names <- function(from_gbm){
    Map(function(a){a[[1]]},
        str_split(from_gbm,":")) %>% unlist()
}
results <- do.call(rbind, Map(function(nv){
    train_ctrl <- trainControl(method = "cv", number = 50, verbose=FALSE);
    gbmFit1 <- train(as.formula(sprintf("female ~ %s",
                             paste(colums_of_interest,collapse=" + "))), data = info %>% slice(trainIndex), 
                     method = "gbm",
                     trControl = train_ctrl)
    var.inf <- summary(gbmFit1$finalModel) %>% as_tibble();
    old_coi <- paste(colums_of_interest,collapse=" + ");
    colums_of_interest <<- extract_var_names(var.inf$var[1:nv]);
    tibble(n_variables=nv, accuracy=max(gbmFit1$results$Accuracy),
           variables=old_coi);
},seq(from=length(colums_of_interest)-1,to=1,by=-1)));
results;
```




```
# A tibble: 4 x 3
  n_variables accuracy variables                                           
        <dbl>    <dbl> <chr>                                               
1           4    0.869 height + weight + eye_color + skin_color + publisher
2           3    0.873 weight + height + eye_color + publisher             
3           2    0.873 weight + height + eye_color                         
4           1    0.869 weight + height                                     
```

Conclusions
===========

Models are themselves random objects that depend on the selection of
training and testing data.

Thus, we must find a way to estimate their expected properties if we
are to characterize them accurately.

The methods typically used (if access to arbitarily large test data is
not available) are:

1. Cross Validation
   Hold out N samples repeatedly in "folds", train and characterize the model.
2. Bootstrapping Draw repeatedly from the data set and then split the
   results into train and test sets. Train your model and calculate
   the statistics.
   
These simple descriptions somewhat understand the complexity of the
issues involved.

   
