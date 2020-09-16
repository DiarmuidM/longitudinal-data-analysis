/** Longitudinal Data Analysis for Social Scientists **/
/*
*
* This syntax file demonstrates how to estimate a range of panel data models,
* and run through a suite of statistical tests to guide selection of appropriate model.
*/


/* 1. Defining panel data */

use "C:\Users\t95171dm\projects\longitudinal-data-analysis\data\charity-panel-analysis-2020-09-10.dta", clear

xtset regno fin_year // set data as panel (cross-sectional time series) data
xtdescribe

by regno: gen numobs = _N // create measure of number of observations per unit of analysis
xttab numobs


/* 2. Data exploration */

xttab nsources // tabulation
xtsum orgage // summarise

tab1 localc socser


/* 3. Pooled OLS */

regress linc orgage localc west genchar nsources govern_share
est store pols


/* 4. Between Effects */

xtreg linc orgage localc west genchar nsources govern_share, be
est store beff

** Equivalent method of producing a Between Effects model

preserve
    collapse (mean) linc orgage localc west genchar nsources govern_share, by(regno)
    regress linc orgage localc west genchar nsources govern_share
    est store coll
restore


/* 5. Fixed Effects */

xtreg linc orgage localc west genchar nsources govern_share, fe
est store feff

** Post-estimation commands

capture predict fixed, u
capture predict y_hat, xb
capture predict ei, e
capture predict residuals, ue
capture egen pickone = tag(regno)

** View unit-specific effects and other residuals

l regno fin_year fixed if pickone in 1/100
l regno fin_year linc y_hat residuals fixed ei in 1/11

* help xtreg postestimation


/* 6. Random Effects */

xtreg linc orgage localc west genchar nsources govern_share, re
* xtreg linc orgage localc west genchar nsources govern_share // defaults to Random Effects if you don't specify an option
est store reff

** Post-estimation commands

capture predict random, u
capture predict y_hat, xb
capture predict ei, e
capture predict residuals, ue
capture egen pickone = tag(regno)

** View unit-specific effects and other residuals

l regno fin_year random if pickone in 1/100
l regno fin_year linc y_hat residuals random ei in 1/11

* help xtreg postestimation


/* 7. Model checking */

** 7.1. Is the Pooled OLS model appropriate?

*net sj 3-2 st0039
*net install st0039

xtserial linc orgage localc west genchar nsources govern_share // test of serial (auto)correlation

regress linc orgage localc west genchar nsources govern_share, cluster(regno) // relax key regression assumptions (i.i.d errors).

quietly xtreg linc orgage localc west genchar nsources govern_share, re // check how Pooled OLS compares to Random Effects
xttest0


** 7.2. Fixed or Random Effects?

quietly xtreg linc orgage localc west genchar nsources govern_share, fe
est store fixed

quietly xtreg linc orgage localc west genchar nsources govern_share, re
est store random

hausman fixed random // Hausman test


/* 8. Extensions */

** 8.1. Hybrid models

bys regno: egen nsources_mn = mean(nsources)
gen nsources_delta = nsources - nsources_mn

xtreg linc orgage localc west genchar nsources_mn nsources_delta govern_share, re // decompose coefficients into within and between effects

test nsources_mn = nsources_delta // check whether coefficients are equal


** 8.2. Mundlak approach

bys regno: egen orgage_mn = mean(orgage)
bys regno: egen govern_share_mn = mean(govern_share)

xtreg linc orgage localc west genchar nsources govern_share govern_share_mn nsources_mn orgage_mn, re // add unit-level means of the time-varying variables
est store mund

test govern_share_mn = nsources_mn = orgage_mn // check whether unit-level means equal zero



/* ----------------------------------------------------------------------------*/


** License: https://github.com/DiarmuidM/longitudinal-data-analysis/blob/master/LICENSE

/** --END-- **/
