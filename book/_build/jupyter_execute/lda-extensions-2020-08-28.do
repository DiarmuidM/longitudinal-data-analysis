# Extensions

In this section we provide a whistle-stop tour of some additional techniques and approaches for panel data and longitudinal data more broadly.

## Nonlinear outcomes

Fixed Effects and Random Effects models can be applied to nonlinear outcomes (e.g., binary and count dependent variables) also.

Here is a published example from McDonnell (2017): [https://doi.org/10.1177/0899764017692039](https://doi.org/10.1177/0899764017692039)

use "../data/improvingcharityaccountability_20170411.dta", clear

gen localc = (geographicalspread==2)
gen linc = ln(totalfunds) if totalfunds > 0 & totalfunds!=.

tab yearsubmitted excgroup_3 

xtlogit excgroup_3 concentration charityage localc linc, or re

use "../data/charity-panel-analysis-2020-09-10.dta", clear

xtpoisson nsources linc orgage localc west genchar govern_share, re

## Hybrid panel data models

A hybrid panel model allows you to decompose the observed explanatory variables into their within and between effects using the Random Effects estimator.

Let's return to our charity data example and see if we can decompose the effect of `nsources` into its within and between effects.

use "../data/charity-panel-analysis-2020-09-10.dta", clear

bys regno: egen nsources_mn = mean(nsources)
gen nsources_delta = nsources - nsources_mn

xtreg linc orgage localc west genchar nsources_mn nsources_delta govern_share, re

The coefficients for `nsources_mn` and `nsources_delta` are equal to those estimated in the Between Effects and Fixed Effects models respectively.

Furthermore we can test whether the between and within effects are equal:

test nsources_mn = nsources_delta

An equivalent approach is to use the `mundlak` command:

mundlak linc orgage localc west genchar nsources govern_share, hybrid

## Mundlak approach

Random Effects model assumes that observed and unobserved effects are uncorrelated - an often unrealistic assumption (Gayle and Lambert, 2018).

We can relax this assumption using the *Mundlak approach*, which works by including unit-level means for the time-varying explanatory variables in the Random Effects model.

bys regno: egen orgage_mn = mean(orgage)
bys regno: egen govern_share_mn = mean(govern_share)

xtreg linc orgage localc west genchar nsources govern_share ///
    govern_share_mn nsources_mn orgage_mn, re
est store mund

quietly xtreg linc orgage localc west genchar nsources govern_share, fe
est store fixed

est table fixed mund

quietly xtreg linc orgage localc west genchar nsources govern_share ///
    govern_share_mn nsources_mn orgage_mn, re

test govern_share_mn = nsources_mn = orgage_mn

The *Mundlak approach* is an alternative to the *Hausman test*.

## Dynamic panel models

The models are suitable for when you have repeated contacts data and your (lagged) outcome variable serves also serves as one of your explanatory variables.

The inclusion of lagged outcome variables poses as an issue as the lagged variables are possibly correlated with the unobserved effects (Gayle and Lambert, 2018).

use "../data/charity-panel-analysis-2020-09-10.dta", clear
xtset regno fin_year

capture gen linc_lag = L.linc
l regno fin_year linc linc_lag in 1/22, clean

xtreg linc orgage localc west genchar nsources govern_share linc_lag, re

Note how large the coefficient is for the lagged variable (and how much smaller the others have become). This is a common issue when including lagged outcome variables as one of the explanatory variables i.e., the lagged variable soaks up all of the variation accounted for by the unobserved unit-specific effects. 

xtreg linc orgage localc west genchar nsources govern_share linc_lag, fe

A set of dynamic panel models &mdash; commonly known as *Arrelano-Bond* models &mdash; have been developed to address the inclusion of a lagged outcome as an explanatory variable.

They also have the advantage of controlling for "initial conditions".

That is, data collection sometimes interrupts an ongoing social process, and thus the outcome observed at the first time point is partially accounted for factors not measured at first time point (Gayle and Lambert, 2018).

## Latent growth curve models

Statistical modelling of repeated contacts data.

Focuses on trajectory, trend or growth in an outcome over time **within** units.

And how these trajectories are linked to observed and unobserved differences **between** units.

Latent growth curve models can be estimated using a *Multilevel modelling* framework &mdash; random intercepts, random slopes.

They can also be estimated using a *Structural Equation Modelling (SEM)* framework &mdash;  there exists underlying continuous trajectory of change that is not directly observed.

**Honesty time**

[Not an area I know a great deal about - see the reading list for suggested resources]