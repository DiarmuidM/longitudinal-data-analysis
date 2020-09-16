# Panel Data Analysis V

In this section we estimate a panoply of panel data models and try to determine which one is most appropriate for our data. We outline some tests &mdash; statistical and conceptual &mdash; that can be used to select from a set of panel data models.

## Quick reminder

Let's quickly remind ourselves of the key questions we need to ask before estimating panel data models:
1. How do your explanatory variables influence the outcome?
2. Is your statistical model specified correctly?

Let's see how these questions map to the various panel data models we can estimate, and what tests we can run to help us select the most appropriate model (if it exists).

## Defining our statistical model

Let's return to our panel data on charities and define a statistical model for predicting a charity's annual gross income as a function of its age, the scale of its charitable activities, where it is located, what type of charity it is, and the number of sources of income it has, and the share of its income provided by government.

$$ \text{y}_{it} = \beta_0 + \beta_1x_{1it} + \beta_2x_{2i} + \beta_3x_{3i} + \beta_4x_{4i} + \beta_5x_{5it} + \beta_6x_{6it} + \epsilon_{it} \tag{1.6} $$

### How do your explanatory variables influence the outcome?

We are interested in a model that allows us to include observed time-invariant explanatory variables, as these are of substantive interest. For example, are local charities typically smaller than national or international organisations?

It is possible that the effect of the observed time-varying explanatory variables may differ depending on whether we consider them from a within or between perspective. For example, the effect of gaining an additional income source &mdash; say new funding from government &mdash; may be different for a change within an individual charity than a comparison of two charities.

### Is your statistical model specified correctly?

We would be surprised if there wasn't a correlation between the observed explanatory variables and the unobserved unit-specific effects. We only have six observed explanatory variables in the model, of which some do not vary much within charities (e.g., number of income sources), and some do not vary much between charities (e.g., a charity is either a social services organisation or not).

So before estimating models, we clearly want one that includes **observed time-invariant explanatory variables** and addresses the likely violation of **independence of errors** assumption.

## Estimating models

### Pooled OLS

Is the Pooled OLS model appropriate? That is, can we ignore the fact that charities likely differ in unobserved ways?

use "../data/charity-panel-analysis-2020-09-10.dta", clear

regress linc orgage localc west genchar nsources govern_share
est store pols

We can perform an *autocorrelation* test to check whether *independence of errors* assumption is violated:

*net sj 3-2 st0039
*net install st0039

xtserial linc orgage localc west genchar nsources govern_share

The results of the Wooldridge strongly suggest the error terms are correlated across observations. In practice this means that the values of these variables typically vary less *within* than across units. An obvious example would be the `orgage` variable:

l regno orgage in 1/11, clean

tabstat orgage, s(min max)

xtsum orgage

* Overall results suggest the average age of a charity 39.
* Between results collapse data set down to one row per unit, hence slightly different figures to overall results. Min and Max now refer to average values.
* Within results calculate differences between observed value for a unit in a given period and the unit's mean value across all periods (and the global mean also, hence why results are counter-intuitive).

The presence of serial (auto) correlation suggests we cannot ignore the panel component of the data. However, that does not mean we need to estimate a panel model. We could use the `regress, cluster()` approach to relax the assumption that the error terms are independent and uncorrelated with the explanatory variables.

regress linc orgage localc west genchar nsources govern_share, cluster(regno)

We no longer have underestimated standard errors, resulting in more more accurate t tests of the coefficients (note some variables are no longer statistically significant). However we may still want to control for unit-specific differences in the outcome &mdash; that is, is some of the variation in the outcome explained by unobserved heterogeneity?

We can check whether a Random Effects model is preferred over Pooled OLS by conducting a *Breusch and Pagan Lagrangian multiplier test*.

quietly xtreg linc orgage localc west genchar nsources govern_share, re
xttest0

Rejection of the null hypothesis suggests that there is a panel effect on the outcome, and that a Random Effects model is preferred over Pooled OLS.

### Fixed Effects or Random Effects?

For most repeated contacts data sets, it would be erroneous to ignore the panel component of the data, even after controlling for autocorrelation of the error terms. 

We then have a choice between Fixed Effects and Random Effects. (We ignore the Between Effects model as it is rarely insightful on its own, and is captured by the Random Effects model anyway.)

**Hausman Test**

The *Hausman test* checks whether the coefficients of the Random Effects model are consistent &mdash; that is, equivalent to those from the Fixed Effects model.  

Failure to reject the null hypothesis (they are equivalent) provides evidence in favour of the Random Effects model, otherwise the Fixed Effects model is considered more appropriate.

quietly xtreg linc orgage localc west genchar nsources govern_share, fe
est store fixed

quietly xtreg linc orgage localc west genchar nsources govern_share, re
est store random

hausman fixed random

In our example, it appears that the coefficients from the Random Effects model are inconsistent and thus the Fixed Effects model should be preferred. 

Often you'll find that the *Hausman test* favours the Fixed Effects model but this isn't definitive proof that it is more appropriate.

## Guidance on selecting an appropriate model

Confusing and conflicting advice is found throughout the statistical literature (Gelman and Hill, 2007).

In quantitative social science there is probably more support for Random Effects lately. Clark et al. (2010) state that Fixed Effects has its advantages but it limits the type of research questions that can be addressed.

Random Effects has qualities close to Fixed Effects where rich data are available i.e., where lots of observed time-varying explanatory variables are captured (Gayle and Lambert, 2018).

Selecting a model should first-and-foremost draw on theoretical insight on the relationship between the explanatory variables and the outcome.

Undertake the *Hausman test* but don't be bound by it (Gayle and Lambert, 2018).

Estimate theoretically plausible statistical models and carefully compare their results.

## Summary

**QUESTION** 

Which model of charity income would you choose and why? 

Based on all of the guidance and the results of the statistical tests, I selected the Random Effects model.