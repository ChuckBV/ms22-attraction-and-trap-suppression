#============================================================================
# script8_y19_nonmd_stats.R
#
#
#============================================================================

## Restart R

### Full factorial model
library(lme4)
library(MASS)
library(car)
library(emmeans)

# Load data
dat <- readRDS("./data/y19_md_trapsums.Rds")
#     NB lure and row both are and ought to be factors
head(dat)
#         lure row Sum
# 1 NowBiolure   1   0
# 2 NowBiolure   2   0
# 3 NowBiolure   3   0
# 4 NowBiolure   4   0
# 5 NowBiolure   5   1
# 6 NowBiolure   6   0

unique(dat$lure)
# [1] NowBiolure      CidetrakNOW_1in CidetrakNOW_4in CidetrakNOW_8in AldTCP_1in      AldTCP_4in     
# [7] AldTCP_12in     BiolurePpo     
# 8 Levels: NowBiolure CidetrakNOW_1in CidetrakNOW_4in CidetrakNOW_8in AldTCP_1in AldTCP_4in ... BiolurePpo

# Didn't actually get sums

# run model
model <- glmer.nb(Sum ~ lure + (1 | row), data = dat)

summary(model)
# Generalized linear mixed model fit by maximum likelihood (Laplace Approximation) ['glmerMod']
# Family: Negative Binomial(1.8913)  ( log )
# Formula: Sum ~ lure + (1 | row)
# Data: dat
# 
# AIC      BIC   logLik deviance df.resid 
# 397.8    419.4   -188.9    377.8       54 
# 
# Scaled residuals: 
#   Min      1Q  Median      3Q     Max 
# -1.3344 -0.5619 -0.2922  0.5422  2.9075 
# 
# Random effects:
# Groups Name        Variance Std.Dev.
# row    (Intercept) 0.02439  0.1562  
# Number of obs: 64, groups:  row, 8
# 
# Fixed effects:
#   Estimate Std. Error z value Pr(>|z|)    
# (Intercept)           -2.095      1.035  -2.024  0.04295 *  
# lureCidetrakNOW_1in    1.386      1.176   1.179  0.23842    
# lureCidetrakNOW_4in    3.362      1.081   3.111  0.00186 ** 
# lureCidetrakNOW_8in    3.169      1.084   2.924  0.00346 ** 
# lureAldTCP_1in         4.805      1.070   4.489 7.15e-06 ***
# lureAldTCP_4in         5.917      1.066   5.552 2.83e-08 ***
# lureAldTCP_12in        5.446      1.067   5.106 3.29e-07 ***
# lureBiolurePpo         6.025      1.067   5.645 1.65e-08 ***
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Correlation of Fixed Effects:
# (Intr) lCNOW_1 lCNOW_4 lCNOW_8 lrATCP_1 lATCP_4 lATCP_12
# lrCdtrNOW_1 -0.876                                                  
# lrCdtrNOW_4 -0.953  0.839                                           
# lrCdtrNOW_8 -0.950  0.837   0.910                                   
# lrAldTCP_1n -0.960  0.847   0.922   0.920                           
# lrAldTCP_4n -0.967  0.851   0.926   0.923   0.934                   
# lrAldTCP_12 -0.967  0.850   0.924   0.922   0.932    0.938          
# lureBiolrPp -0.968  0.850   0.924   0.921   0.929    0.938   0.938  

anova_result <- Anova(model, type = "II")
print(anova_result)
# Analysis of Deviance Table (Type II Wald chisquare tests)
# 
# Response: Sum
#       Chisq Df Pr(>Chisq)    
# lure 146.84  7  < 2.2e-16 ***
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

emmeans_nb <- emmeans(model, "lure")
pairs(emmeans_nb)
# contrast                          estimate    SE  df z.ratio p.value
# NowBiolure - AldTCP_12in            0.7717 0.245 Inf   3.144  0.0356
# NowBiolure - AldTCP_4in             1.1558 0.249 Inf   4.647  0.0001
# NowBiolure - AldTCP_1in             1.1100 0.249 Inf   4.449  0.0002
# NowBiolure - CidetrakNOW_8in        4.5660 0.321 Inf  14.206  <.0001
# NowBiolure - CidetrakNOW_4in        4.3210 0.306 Inf  14.106  <.0001
# NowBiolure - CidetrakNOW_1in        4.5253 0.319 Inf  14.173  <.0001
# NowBiolure - BlankCtrl              7.6917 1.029 Inf   7.472  <.0001
# AldTCP_12in - AldTCP_4in            0.3841 0.248 Inf   1.550  0.7803
# AldTCP_12in - AldTCP_1in            0.3383 0.250 Inf   1.352  0.8788
# AldTCP_12in - CidetrakNOW_8in       3.7943 0.321 Inf  11.817  <.0001
# AldTCP_12in - CidetrakNOW_4in       3.5493 0.308 Inf  11.541  <.0001
# AldTCP_12in - CidetrakNOW_1in       3.7536 0.319 Inf  11.758  <.0001
# AldTCP_12in - BlankCtrl             6.9200 1.030 Inf   6.722  <.0001
# AldTCP_4in - AldTCP_1in            -0.0458 0.249 Inf  -0.184  1.0000
# AldTCP_4in - CidetrakNOW_8in        3.4102 0.322 Inf  10.598  <.0001
# AldTCP_4in - CidetrakNOW_4in        3.1652 0.308 Inf  10.264  <.0001
# AldTCP_4in - CidetrakNOW_1in        3.3694 0.319 Inf  10.549  <.0001
# AldTCP_4in - BlankCtrl              6.5359 1.030 Inf   6.347  <.0001
# AldTCP_1in - CidetrakNOW_8in        3.4560 0.323 Inf  10.701  <.0001
# AldTCP_1in - CidetrakNOW_4in        3.2110 0.309 Inf  10.406  <.0001
# AldTCP_1in - CidetrakNOW_1in        3.4152 0.322 Inf  10.619  <.0001
# AldTCP_1in - BlankCtrl              6.5817 1.030 Inf   6.390  <.0001
# CidetrakNOW_8in - CidetrakNOW_4in  -0.2450 0.370 Inf  -0.662  0.9979
# CidetrakNOW_8in - CidetrakNOW_1in  -0.0408 0.380 Inf  -0.107  1.0000
# CidetrakNOW_8in - BlankCtrl         3.1257 1.050 Inf   2.977  0.0584
# CidetrakNOW_4in - CidetrakNOW_1in   0.2042 0.369 Inf   0.554  0.9993
# CidetrakNOW_4in - BlankCtrl         3.3707 1.046 Inf   3.223  0.0278
# CidetrakNOW_1in - BlankCtrl         3.1665 1.049 Inf   3.018  0.0519

Results are given on the log (not the response) scale. 
P value adjustment: tukey method for comparing a family of 8 estimates 