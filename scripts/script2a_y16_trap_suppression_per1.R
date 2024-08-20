#============================================================================
# script2a_y16_trap_suppression_per1.R
#
# PARTS
# 1. Import data (line 28)
# 2. Produce summary statistics (line 60)
# 3. Plot the data (line 73)
# 4. Perform non-parametric ANOVA (line 94)
# 
#============================================================================

library(tidyverse)


dat <- read_csv("./data/y16_per1_sasdat.csv",
         col_types = c("f","i","i","c","d","i","c","i","i","f","f"))


dat %>% 
  group_by(Blend,PerHa) %>% 
  summarise(nObs = n(),
            mn = mean(Plotsum, na.rm = T),
            sem = FSA::se(Plotsum))
# # A tibble: 6 × 5
# # Groups:   Blend [2]
#   Blend   PerHa  nObs    mn    sem
#   <chr>   <dbl> <int> <dbl>  <dbl>
# 1 Ald        17     4 57    15.7  
# 2 Ald        30     4 37.2  16.7  
# 3 Ald        69     4  6.75  2.84 
# 4 Ald+TCP    17     4 62.5  16.0  
# 5 Ald+TCP    30     4 14.8   3.64 
# 6 Ald+TCP    69     4  3     0.816

## Restart R

### Full factorial model
library(lme4)
library(MASS)
library(car)
install.packages("emmeans") 
library(emmean)

dat$PerHa <- factor(dat$PerHa, levels = unique(dat$PerHa))

model <- glmer.nb(Plotsum ~ Blend * PerHa + (1 | Rep), data = dat)

summary(model)
# Generalized linear mixed model fit by maximum likelihood (Laplace Approximation) ['glmerMod']
# Family: Negative Binomial(7.8202)  ( log )
# Formula: Plotsum ~ Blend * PerHa + (1 | Rep)
# Data: dat
# 
# AIC      BIC   logLik deviance df.resid 
# 183.8    190.9    -85.9    171.8       18 
# 
# Scaled residuals: 
#   Min       1Q   Median       3Q      Max 
# -1.56967 -0.57511 -0.09092  0.43528  1.84826 
# 
# Random effects:
#   Groups Name        Variance Std.Dev.
# Rep    (Intercept) 0.2214   0.4705  
# Number of obs: 24, groups:  Rep, 4
# 
# Fixed effects:
#   Estimate Std. Error z value Pr(>|z|)    
# (Intercept)         4.617028   0.338518  13.639  < 2e-16 ***
#   BlendAld+TCP        0.243934   0.352813   0.691   0.4893    
# PerHa              -0.040383   0.006329  -6.381 1.76e-10 ***
#   BlendAld+TCP:PerHa -0.019100   0.010021  -1.906   0.0567 .  
# ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Correlation of Fixed Effects:
#   (Intr) BlA+TCP PerHa 
# BlndAld+TCP -0.496               
# PerHa       -0.617  0.589        
# BlnA+TCP:PH  0.391 -0.853  -0.629

anova_result <- Anova(model, type = "II")
print(anova_result)
# Analysis of Deviance Table (Type II Wald chisquare tests)
# 
# Response: Plotsum
# Chisq Df Pr(>Chisq)    
# Blend         4.9775  1    0.02568 *  
#   PerHa       127.1350  2    < 2e-16 ***
#   Blend:PerHa   8.8980  2    0.01169 *  
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

### Model for Ald only
ald_only <- dat[dat$Blend == "Ald",]

m2 <- glmer.nb(Plotsum ~ PerHa + (1 | Rep), data = ald_only)

summary(m2)

anova_result2 <- Anova(m2, type = "II")
print(anova_result2)
# Analysis of Deviance Table (Type II Wald chisquare tests)
# 
# Response: Plotsum
# Chisq Df Pr(>Chisq)    
# PerHa 48.604  1  3.132e-12 ***
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

# Means separation using emmeans
emmeans_nb2 <- emmeans(anova_result2, ~ PerHa)
pairs(emmeans_nb2)