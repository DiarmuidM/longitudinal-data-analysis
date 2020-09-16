<h1>Table of Contents<span class="tocSkip"></span></h1>
<div class="toc"><ul class="toc-item"><li><span><a href="#Quick-reminder" data-toc-modified-id="Quick-reminder-1"><span class="toc-item-num">1&nbsp;&nbsp;</span>Quick reminder</a></span></li><li><span><a href="#Defining-our-statistical-model" data-toc-modified-id="Defining-our-statistical-model-2"><span class="toc-item-num">2&nbsp;&nbsp;</span>Defining our statistical model</a></span><ul class="toc-item"><li><span><a href="#Decomposition-implications" data-toc-modified-id="Decomposition-implications-2.1"><span class="toc-item-num">2.1&nbsp;&nbsp;</span>Decomposition implications</a></span></li><li><span><a href="#A-word-of-caution" data-toc-modified-id="A-word-of-caution-2.2"><span class="toc-item-num">2.2&nbsp;&nbsp;</span>A word of caution</a></span></li></ul></li><li><span><a href="#Fixed-Effects-Model" data-toc-modified-id="Fixed-Effects-Model-3"><span class="toc-item-num">3&nbsp;&nbsp;</span>Fixed Effects Model</a></span><ul class="toc-item"><li><span><a href="#Conceptualising-the-Fixed-Effects-model" data-toc-modified-id="Conceptualising-the-Fixed-Effects-model-3.1"><span class="toc-item-num">3.1&nbsp;&nbsp;</span>Conceptualising the Fixed Effects model</a></span></li><li><span><a href="#Estimation" data-toc-modified-id="Estimation-3.2"><span class="toc-item-num">3.2&nbsp;&nbsp;</span>Estimation</a></span></li><li><span><a href="#Interpretation" data-toc-modified-id="Interpretation-3.3"><span class="toc-item-num">3.3&nbsp;&nbsp;</span>Interpretation</a></span></li><li><span><a href="#Post-estimation" data-toc-modified-id="Post-estimation-3.4"><span class="toc-item-num">3.4&nbsp;&nbsp;</span>Post-estimation</a></span></li><li><span><a href="#Benefits-of-Fixed-Effects" data-toc-modified-id="Benefits-of-Fixed-Effects-3.5"><span class="toc-item-num">3.5&nbsp;&nbsp;</span>Benefits of Fixed Effects</a></span></li><li><span><a href="#Limitations-of-Fixed-Effects" data-toc-modified-id="Limitations-of-Fixed-Effects-3.6"><span class="toc-item-num">3.6&nbsp;&nbsp;</span>Limitations of Fixed Effects</a></span></li><li><span><a href="#Summarising-the-Fixed-Effects-model" data-toc-modified-id="Summarising-the-Fixed-Effects-model-3.7"><span class="toc-item-num">3.7&nbsp;&nbsp;</span>Summarising the Fixed Effects model</a></span></li></ul></li><li><span><a href="#Summary" data-toc-modified-id="Summary-4"><span class="toc-item-num">4&nbsp;&nbsp;</span>Summary</a></span></li></ul></div>

# Panel Data Analysis III

In this section we estimate a statistical model that leverages some of the main advantages of using panel data: **Fixed Effects**. We show some examples of how to estimate and interpret this model, and reflect on the conditions under which the model is appropriate.

## Quick reminder

Let's briefly recap some essential concepts regarding panel data:

Two sources of variation ([Gould, n.d.](https://www.stata.com/support/faqs/statistics/between-estimator/)): 
1. Cross-section information on differences between units
2. Time series information on differences over time within units

So far our panel data models &mdash; Pooled OLS and Between Effects &mdash; only allow us to examine differences between units.

Two main issues with estimating statistical models:
1. Interdependence of errors
2. Improper model specification

The first can lead to inefficient estimates: under-estimated standard errors and false positive tests of statistical significance.

The second to biased coefficients and incorrect inferences regarding magnitude and direction of effect of explanatory variables.

Therefore we need a statistical model that allows us to **examine change over time** and/or **control for omitted variable bias**.

## Defining our statistical model

Before estimating Fixed Effects and Random Effects models separately, it is worth identifying the key commonality between their respective statistical models.

Let's take a simplified version of our charity income statistical model, this time with only one explanatory variable (*age*) - typically it looks as follows:

$$ \text{y}_{it} = \beta_0 + \beta_1x_{1it} + \epsilon_{it} \tag{1.7} $$

However it is possible to **decompose** the residual variation (error term) into two separate terms:

$$ \text{y}_{it} = \beta_0 + \beta_1x_{1it} + \mu_{i} + \text{e}_{it} \tag{1.8} $$

In equation 1.8. we have introduced a **unit-specific** term to represent some of the residual variation in the outcome that is unexplained by the explanatory variables.

### Decomposition implications

This term ($\mu_{i}$) captures the effect of *residual heterogeneity* on the outcome i.e., unobserved or immeasurable characteristics of the units that are associated with the outcome (and possibly the explanatory variables), and vary across units.

In our charity data example, these charity-specific effects could be organisational culture, informal connections to government etc. In theory these characteristics could be measured but it's often wildly impractical.

The unit-specific effect also controls for the effect of other omitted variables on the outcome (and possibly the explanatory variables).

In our charity data example, we do not include explanatory variables capturing the amount a charity spends on fundraising, how well known it is etc. 

### A word of caution

Note the lack of a time subscript *t* in the new term $\mu_{i}$. The implication is that the unobserved unit-specific effect is **constant** over time (i.e., within units).

Therefore Fixed Effects and Random Effects models only control for omitted variables that do not change within units (e.g., race, sex at birth, natural ability).

## Fixed Effects Model

### Conceptualising the Fixed Effects model

1. The Fixed Effects model focuses on how changes in explanatory variables are associated with changes in the outcome **within units**.
2. It assumes the observed explanatory variables and unobserved unit-specific effect are correlated (i.e., omitted variable bias is an issue).

Mehmetoglu and Jakobsen (2016, p. 241):
> "In other words, we use fixed effects whenever we are only interested in the impact of variables that vary over time. This estimator helps us explore the relationship between the dependent and the explanatory variables within a unit (person, company, country, etc.) Each unit has its own individual characteristics that may or may not influence the predictor variables."

The Fixed Effects model is specified as follows:

$$ \text{y}_{it} = \beta_0 + \lambda_{i} + \beta_1x_{1it} +...+ \beta_kx_{kit} + \text{e}_{it} \tag{1.9} $$

Where:

$\lambda_{i}$ represents the unit-specific effect on the outcome.

The value of $\lambda_{i}$ captures the effect of **all** of the unobserved time-invariant explanatory variables that are missing from the model. As a result, while the value of $\lambda_{i}$ is calculated, it is not of much interest in and of itself. It's main role is to allow for a more robust (i.e., unbiased) estimation of the effects of the explanatory variables in the model.

In essence the Fixed Effects model produces a unit-specific intercept, which is the sum of the overall constant and the unit-specific effect:

$$ \text{y}_{it} = \alpha_{i} + \beta_1x_{1it} +...+ \beta_kx_{kit} + \text{e}_{it} \tag{1.10} $$

Where:

$\alpha_{i} = \beta_0 + \lambda_{i}$

The unit-specific effect shifts the overall intercept up or down the y axis by the value of $\lambda$.

#### Final thoughts on conceptualisation

Consider the Fixed Effects model a standard cross-sectional regression model with the addition of a dummy variable being for every unit in the panel except for one (i.e., *n - 1* dummy variables are added as explanatory variables).

### Estimation

use "../data/charity-panel-analysis-2020-09-10.dta", clear

xtreg linc orgage localc west genchar nsources govern_share, fe

**QUESTION TIME**

1. How much of the variation in the outcome is accounted for by the model? Is this a lot?
2. Why were three of the observed explanatory variables excluded in the estimation of the model?
3. What does the $\text{rho}$ statistic tell us?
4. Is there evidence of correlation between the unit-specific effects and observed explanatory variables?

### Interpretation

The effect of the observed explanatory variables is **net of** the effect of the unit-specific term. That is, we've controlled for the correlation between *X* and $\mu_{i}$.

$\text{_cons}$ is the intercept and represents the average value of the fixed effects + the overall constant.

$\text{orgage}$ is the predicted change in the outcome for a one-unit increase in organisational age.

$\text{rho}$ is the proportion of unexplained variance in the outcome explained by unobserved differences between charities (the unit-specific effects), rather than changes within them.

If $\text{rho}$ > .5 then most of the residual variation in the outcome is due to differences between units, if $\text{rho}$ < .5 then most of the residual variation is accounted for by differences within units (i.e., the effects of the explanatory variables).

$\text{corr(u_i, Xb)}$ is the correlation between the unit-specific effect and the observed explanatory variables in the model.

* $\text{sigma_u}$ (or $\sigma_u$) is the standard deviation of the fixed effects (i.e., the residuals within units.
* $\text{sigma_e}$ (or $\sigma_e$) is the standard deviation of residuals ei.
* $\text{R-sq: within}$ is the proportion of variance explained by the observed explanatory variables (i.e., excluding the unit-specific effect).

### Post-estimation

Though it's very rarely of substantive interest, we can recover the unit-specific effects (and other parameter estimates) after estimating a Fixed Effects model:

capture predict fixed, u
capture predict y_hat, xb
capture predict ei, e
capture predict residuals, ue
capture egen pickone = tag(regno)

l regno fin_year fixed if pickone in 1/100

l regno fin_year linc y_hat residuals fixed ei in 1/11

di -.9911593 + -.1846687

tabstat fixed ei, s(mean sd) format(%5.4f)

### Benefits of Fixed Effects

* Analyse change over time.
* Control for residual heterogeneity.
* Coefficient estimates are **consistent** if the key assumption is true. That is, because we have controlled for the effect of unobserved time-invariant explanatory variables, our coefficients are more robust, which means increasing the sample size increases the likelihood the estimates are converging on their true values.

(Mehmetoglu and Jakobsen, 2016)

### Limitations of Fixed Effects

* Ignores differences between units.
* Coefficient estimates are **inefficient**, especially when compared to those from a Random Effects model. As a result, standard errors tend to be larger. Put simply, the estimates of the coefficients are based on only one source of variation (within) and thus are more uncertain.
* Cannot include observed time-invariant explanatory variables. This is due to a very simple reason: if a value does not vary, how can it be associated with variation in the value of another variable?
* Cannot control for unobserved residual heterogeneity that varies over time e.g., educational ability? Natural resilience?
* It is not well suited for variables that rarely change within units.

Think carefully about variables that change little over time - how might these influence the outcome? For example, few individuals in your panel might switch from non-graduate to graduate (let's say you have a sample of older individuals). In a fixed effects model, your estimation of the effect of switching between non-graduate and graduate will be based on a small number of occurrences and care is due in interpreting the coefficient.

### Summarising the Fixed Effects model

Focuses on change over time within a unit of analysis.

Can control for the effect of unobserved time-invariant explanatory variables (residual heterogeneity).

Provides robust estimates of observed explanatory variables when said variables are correlated with unobserved effects.

However cannot include observed explanatory variables that do not vary within units.

## Summary

Both the Pooled OLS and Between Effects models provide useful information on the association between an outcome *Y* and a set of explanatory variables *X*.

Fixed Effects provide potentially different information on the association between an outcome *Y* and a set of explanatory variables *X.

Is there a way to combine the *within* and *between* perspectives?