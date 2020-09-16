# Panel Data Analysis IV

In this section we estimate a statistical model that leverages some of the main advantages of using panel data: **Random Effects**. We show some examples of how to estimate and interpret this model, and reflect on the conditions under which the model is appropriate.

## Quick reminder

Let's briefly recap some essential concepts regarding panel data:

Two sources of variation ([Gould, n.d.](https://www.stata.com/support/faqs/statistics/between-estimator/)): 
1. Cross-section information on differences between units
2. Time series information on differences over time within units

Pooled OLS and Between Effects models only allow us to examine differences between units. Fixed Effects only allow us to examine differences within units.

What if we wanted a model that leveraged aspects of the Between Effects and Fixed Effects estimators? Such a model would give us:
* More variation with which to explain the outcome.
* More flexibilty (e.g., include observed time-invariant explanatory variables).
* Other methodological and modelling benefits (e.g., decomposing explanatory variables into within and between effects).

## Defining our statistical model

Recall the general form of Fixed Effects and Random Effects models:

$$ \text{y}_{it} = \beta_0 + \beta_1x_{1it} + \mu_{i} + \text{e}_{it} \tag{1.8} $$

In equation 1.8. we have introduced a **unit-specific** term to represent some of the residual variation in the outcome that is unexplained by the explanatory variables.

This term ($\mu_{i}$) captures the effect of *residual heterogeneity* on the outcome i.e., unobserved or immeasurable characteristics of the units that are associated with the outcome (and possibly the explanatory variables), and vary across units.

### A word of caution

Note the lack of a time subscript *t* in the new term $\mu_{i}$. The implication is that the unobserved unit-specific effect is **constant** over time (i.e., within units).

Therefore Fixed Effects and Random Effects models only control for omitted variables that do not change within units (e.g., race, sex at birth, natural ability).

## Random Effects Model

### Conceptualising the Random Effects model

1. The Random Effects model focuses on how changes in explanatory variables are associated with changes in the outcome **within and between units**.
2. It assumes the observed explanatory variables and unobserved unit-specific effects are **not** correlated. In essence: the unobserved unit-specific effect explains some of the variation in the outcome, but is not associated with any of the observed explanatory variables.

Gayle and Lambert (2018, p. 68):
> ...the random effects panel model is a matrix weighted average of the within-effects (fixed effects) and the between effects.

In essence the Random Effects model borrows some information from the Between Effects model and some from the Fixed Effects model.

Therefore the coefficients in a Random Effects model allow you to speak in terms of the effect of an explanatory variable on an outcome, whether we are comparing different individuals or different observations for the same individual - we'll see what this means when we estimate our first Random Effects model.

The Random Effects model is specified as follows:

$$ \text{y}_{it} = \beta_0 + \beta_1x_{1it} +...+ \beta_kx_{kit} + \upsilon_{i} + \text{e}_{it} \tag{1.11} $$

Where:

$\upsilon_{i}$ represents the unit-specific effect on the outcome.

As we assume the observed explanatory variables and unobserved unit-specific effects are **not** correlated, there is no need to estimate $\upsilon_{i}$ as if it were an explanatory variable and hence why it is part of the error component of the model.

Remember, it would only need to be estimated in the model if it would alter the coefficients for the observed explanatory variables: we assume it wouldn't it. Therefore instead of estimating the value of $\upsilon_{i}$ using the data (as we would for the observed explanatory variables), we assume the unit-specific effects are drawn from a known probability distribution (Gayle and Lambert, 2018).

As a result, we are only interested in the variance of $\upsilon_{i}$ and the extent to which it accounts for variation in the outcome.

#### Final thoughts on conceptualisation

In a Random Effects model we are unconcerned with estimating the coefficient of the unit-specific effect. We simply want to know to what degree variation in these unit-specific effects is associated with variation in the outcome.

### Estimation

use "../data/charity-panel-analysis-2020-09-10.dta", clear

xtreg linc orgage localc west genchar nsources govern_share, re

**QUESTION TIME**

1. How much of the variation in the outcome is accounted for by the model? Is this a lot?
2. Why are `localc`, `west` and `genchar` included in the estimation of the model (when they weren't in the Fixed Effects model)?
3. What does the $\text{rho}$ statistic tell us?
4. Is there evidence of correlation between the unit-specific effects and observed explanatory variables?

### Interpretation

The effect of the observed explanatory variables is **not** net of the unit-specific effects. That is, we haven't controlled away any correlation between *X* and $\mu_{i}$ (because we assume they are not correlated).

$\text{_cons}$ is the intercept.

$\text{orgage}$ is the predicted change in the outcome for a one-unit increase in organisational age, **whether age changes within or between units**.

$\text{rho}$ is the proportion of unexplained variance in the outcome explained by unobserved differences between charities (the unit-specific effects), rather than changes within them.

If $\text{rho}$ > .5 then most of the residual variation in the outcome is due to differences between units, if $\text{rho}$ < .5 then most of the residual variation is accounted for by differences within units (i.e., the effects of the explanatory variables).

$\text{corr(u_i, X) = 0}$ is the formal statement of the (untested) assumption that there is no correlation between the unit-specific effect and the observed explanatory variables in the model.

* $\text{sigma_u}$ (or $\sigma_u$) is the standard deviation of the fixed effects (i.e., the residuals within units.
* $\text{sigma_e}$ (or $\sigma_e$) is the standard deviation of residuals ei.
* $\text{R-sq: overall}$ is the proportion of variance explained by the observed explanatory variables (i.e., excluding the unit-specific effect).

### Post-estimation

Though it's very rarely of substantive interest, we can recover the unit-specific effects (and other parameter estimates) after estimating a Random Effects model:

capture predict random, u
capture predict y_hat, xb
capture predict ei, e
capture predict residuals, ue
capture egen pickone = tag(regno)

l regno fin_year random if pickone in 1/100, clean

l regno fin_year y_hat residuals random ei in 1/11, clean

di -1.144261 + -.2037623

tabstat random ei, s(mean sd) format(%5.4f)

### Benefits of Random Effects

* Analyse both change over time and differences between units.
* Control for residual heterogeneity.
* Estimate observed time-invariant explanatory variables in the model.
* Coefficient estimates are **efficient**, especially when compared to those from a Fixed Effects model. As a result, standard errors tend to be smaller. Put simply, the estimates of the coefficients are based on more information than those in the Fixed Effects model, which bases its estimates on only one source of variation (within).

### Limitations of Random Effects

* Key assumption is often unrealistic.
* Coefficient estimates are **inconsistent** if the key assumption is violated.
* That is, if the coefficients for the observed explanatory variables are biased, then increasing the sample size does not necessarily mean we are getting closer to the true value of the parameter.
Difficult to infer whether the value of a coefficient is mainly determined by within or between variation (though there are solutions to this problem).
* Cannot control for unobserved residual heterogeneity that varies over time e.g., educational ability? Natural resilience?

The last point is worth expanding on: if units differ in an unobserved way that varies over time, this will not be controlled for in the Random Effects model.

### Summarising the Random Effects model

Analyses both change within a unit's outcomes, and differences between units' outcomes.

Can control for the effect of unobserved time-invariant explanatory variables (residual heterogeneity).

Can include observed explanatory variables that do not vary within units (e.g., race, sex at birth).

Does not provide robust estimates of observed explanatory variables when said variables are correlated with unobserved unit-specific effects.

## Summary

Both the Pooled OLS and Between Effects models provide useful information on the association between an outcome *Y* and a set of explanatory variables *X*.

Fixed Effects provide potentially different information on the association between an outcome *Y* and a set of explanatory variables *X.

Random Effects combines the *within* and *between* perspectives - methodological and substantive benefits.