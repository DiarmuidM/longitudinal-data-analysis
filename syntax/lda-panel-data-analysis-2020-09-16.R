## Longitudinal Data Analysis for Social Scientists ##
#
#
# This syntax file demonstrates how to estimate a range of panel data models,
# and run through a suite of statistical tests to guide selection of appropriate model.
#
#

# 0. Preliminaries #

my_packages <- c("broom", "haven", "plm")
install.packages(my_packages, repos = "http://cran.rstudio.com")

library(broom)
library(haven)
library(plm)


# 1. Defining panel data #

chardata <- read_dta("C:/Users/t95171dm/projects/longitudinal-data-analysis/data/charity-panel-analysis-2020-09-10.dta")
charpanel <- plm.data(chardata, index=c("regno","fin_year"))


# 2. Pooled OLS #

ols <-lm(linc ~ orgage localc west genchar nsources govern_share, data = chardata)
summary(ols)


# 3. Between Effects #

beff <- plm(linc ~ orgage localc west genchar nsources govern_share, data = charpanel, model= "between")
summary(beff)


# 4. Fixed Effects #

feff <- plm(linc ~ orgage localc west genchar nsources govern_share, data = charpanel, model= "within")
summary(feff)
summary(fixef(feff, type="dmean")) # view unit-specific effects and other residuals
feff_tidy <- tidy(feff, conf.int = TRUE) # use `broom`'s tidy() function to extract model coefficient information)


# 5. Random Effects #

reff <- plm(linc ~ orgage localc west genchar nsources govern_share, data = charpanel, model= "random")
summary(reff)
reff_tidy <- tidy(reff, conf.int = TRUE) # use `broom`'s tidy() function to extract model coefficient information)


# 6. Model checking #

# 7.1. Is the Pooled OLS model appropriate?

plmtest(ols, type = "bp")


# 7.2. Fixed or Random Effects?

phtest(feff, reff)


######################################################################################

# License: https://github.com/DiarmuidM/longitudinal-data-analysis/blob/master/LICENSE

## --END-- ##
