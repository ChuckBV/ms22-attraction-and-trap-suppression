#============================================================================
# script7_y19_nonmd.R
#
# Read and graph data from an August 2019 experiment comparing NOW trapping
# with sections of MESO (mating disruption) dispensers with Ald only, or
# with Ald and TCP. This is the non-MD conducted at the Mike Woolf I-5
# pistachio orchard.
#
# 1. Read in data, show monitoring intervals (line 21)
# 2. Numerical means and SE in table (line 41)
# 3. Box plot of treatment effects (line 82)
# 4. Stats--Kruskal-Wallis, and... (line 107)
#
#============================================================================

library(tidyverse)
library(lubridate)
library(DescTools)
#library(scales)
library(FSA) # for SE function and Dunn Test

#-- 1. Prep treatment names and keys ----------------------------------------

### Treatment names from previous expt in desired order
trt_names <- c("BlankCtrl","CidetrakNOW_1in","CidetrakNOW_4in","CidetrakNOW_8in","AldTCP_1in","AldTCP_4in","AldTCP_12in","NowBiolure")   

### Corresponding treatment names in current expt
trt_names2 <- c("BiolurePpo","CidetrakNOW_1in","CidetrakNOW_4in","CidetrakNOW_8in","AldTCP_1in","AldTCP_4in","AldTCP_12in","NowBiolure")

trt_names2 <- trt_names2[c(8,2:7,1)] # desired order of consideration
trt_names2

trt_key <- read_csv("./data/trt_key.csv")
trt_key <-select(trt_key,trap_id,lure)

#-- 1. Read in data -----------------------------------------

### Read in data file and convert date data types
vverde <- read_csv("./data/y19-vistaverde-meso-lures-data.csv")
vverde$StartDate <- as.Date(mdy(vverde$StartDate))
vverde$EndDate <- as.Date(mdy(vverde$EndDate))
head(vverde,3)
# A tibble: 3 x 7
#     row   pos lure        StartDate EndDate  trap_id Count
#   <dbl> <dbl> <chr>       <chr>     <chr>      <dbl> <dbl>
# 1     1     1 AldTCP_4in  8/28/2019 9/3/2019      11    47
# 2     1     2 AldTCP_12in 8/28/2019 9/3/2019      12    30
# 3     1     3 BlankCtrl   8/28/2019 9/3/2019      13    34

### Merge onto trt_key
dat <- left_join(trt_key,vverde)
head(dat,3)
# A tibble: 3 x 7
# trap_id lure          row   pos StartDate EndDate   Count
#     <dbl> <chr>       <dbl> <dbl> <chr>     <chr>     <dbl>
# 1      11 AldTCP_4in      1     1 8/28/2019 9/3/2019     47
# 2      11 AldTCP_4in      1     1 9/3/2019  9/10/2019    43
# 3      12 AldTCP_12in     1     2 8/28/2019 9/3/2019     30

### Specify factors
dat$lure[dat$lure == "BlankCtrl"] <- "BiolurePpo"
dat <- mutate(dat,lure = factor(lure, levels=trt_names2))
dat$row <- as.factor(dat$row)
head(dat,3)


### How many weeks
dat %>% 
  group_by(EndDate) %>% 
  summarise(nObs = sum(!is.na(Count)))
# EndDate     nObs
# <date>     <int>
# 1 2019-09-
