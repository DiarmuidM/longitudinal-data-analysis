# Panel Data Analysis II

In this section we estimate our first set of statistical models using panel data: **Pooled OLS** and **Between Effects**. We show some examples of how to estimate and interpret these models, and reflect on the conditions under which the models are appropriate.

## What we can relax about

In the sessions demonstrating how to quantitatively analyse panel data, we will cast aside the following concerns:
* Missing data
* Weights
* Attrition
* Multicollinearity

All of these issues impinge on the estimation of panel data models but are not necessary to address for the purposes of learning about said models. We encourage you to consult the [reading list](https://github.com/DiarmuidM/longitudinal-data-analysis/blob/master/reading-list) for suggestions of resources that cover these topics.

## Defining our statistical model

Now we arrive at the interesting bit: estimating statistical models.

Let's return to our panel data on charities and define a statistical model for predicting a charity's annual gross income as a function of its age, the scale of its charitable activities, where it is located, what type of charity it is, and the number of sources of income it has, and the share of its income provided by government.

$$ \text{y}_{it} = \beta_0 + \beta_1x_{1it} + \beta_2x_{2i} + \beta_3x_{3i} + \beta_4x_{4i} + \beta_5x_{5it} + \beta_6x_{6it} + \epsilon_{it} \tag{1.6} $$

Where:

$\text{y}_{it}$ is log income for charity *i* at time *t*

$\beta_0$ is the constant term, which is our prediction for log income when the values of all other variables in the model are set to 0

$\text{x}_{1it}$ captures the age of charity *i* at time *t*, and $\beta_1$ is the effect of this variable on the outcome

$\text{x}_{2i}$ is a dummy variable identifying charities that operate at a local level

$\text{x}_{3i}$ is a dummy variable identifying charities registered in Westminster

$\text{x}_{4i}$ is a dummy variable identifying general charities

$\text{x}_{5it}$ captures the number of sources of income for charity *i* at time *t*

$\text{x}_{6it}$ captures the share its income charity *i* derives from government sources at time *t*

$\epsilon_{it}$ captures the residual for charity *i* at time *t* ($\text{y}_{it} - \hat{y}_{it}$)

## Understanding sources of variation

Remember to keep in mind the two sources of variation that exist in panel data ([Gould, n.d.](https://www.stata.com/support/faqs/statistics/between-estimator/)): 
1. Cross-section information on differences between units
2. Time series information on differences over time within units

## Data exploration

Let's spend a little bit of time exploring the key variables in our statistical model.

use "../data/charity-panel-analysis-2020-09-10.dta", clear

![Histogram of Log Income](./images/linc-histogram.png)

![Histogram of Government Funding Share](./images/govern-histogram.png)

sum orgage, detail

sum nsources, detail

tab1 localc socser

## Pooled OLS Model

The starting point for any statistical modelling of panel data is to estimate a *Pooled OLS* model (fancy way of saying linear regression).

The observations are "pooled", which just means we ignore the nested nature of panel data. In other words we assume that each observation (i.e., row within a long format data set) is independent of other observations (Gayle and Lambert, 2018).

Fundamental problem of pooling observations (Gayle & Lambert, 2018, p. 58):
> The model does not recognise that there are multiple contributions of data from the same individuals, and therefore, it estimates results as if there are many individuals who shared the same characteristics. This impacts upon the estimate of measures such as variances and standard errors.

regress linc orgage localc west genchar nsources govern_share
est store pols

### Conditions where Pooled OLS is suitable

Pooled OLS can produce consistent estimates of the explanatory variables if:
* The model is correctly specified
* The explanatory variables are uncorrelated with the error term (Cameron and Trivedi, 2010)

**TASK:** Do you think our statistical model is correctly specified, and there is no correlation between error term and explanatory variables?

In our statistical model of charity income, it is unlikely that the interpretation of the coefficients would change drastically if we addressed the under-estimation of the standard errors (the sample size is very large).

We'll cover the various tests and checks we can perform to examine whether Pooled OLS model violates the *independence of errors* assumption in a later section.

## Between Effects Model

Once again estimate a cross-sectional model (Pooled OLS). However this time we transform the data so that there is one observation per unit. As a result we end up modelling the mean of Y on the mean of our X variables.

xtreg linc orgage localc west genchar nsources govern_share, be
est store beff

Estimating a Between Effects model is equivalent to collapsing the data and estimating your regression model on the resulting observations:

preserve
    collapse (mean) linc orgage localc west genchar nsources govern_share, by(regno)
    regress linc orgage localc west genchar nsources govern_share
    est store coll
restore

est table pols beff coll

### Benefits of Between Effects

* Sidesteps the problem of interdependence of observations in the original panel data.
* Smooths the effect of anomalous time periods (e.g., excess deaths calculation).
* Controls for omitted variables that change over time but are constant between units (e.g., national policies).

### Limitations of Between Effects

What might the limitations of this approach be?
* Cannot estimate observed variables that change over time but are constant between units (e.g., national policies).
* Discard a lot of information by examining mean outcomes and inputs e.g., change over time.
* Cannot control for unobserved explanatory variables that are constant within but vary between units e.g., organisational culture.

The limitations of the Between Effects model far outweigh the benefits in most cases, and thus it is not widely used in practice (Mehmetoglu and Jakobsen, 2016). However it plays a crucial role in the estimation of another panel data model &mdash; Random Effects model &mdash; and thus it is important to understand how it works and what it offers.

## Summary

Both the Pooled OLS and Between Effects models provide useful information on the association between an outcome *Y* and a set of explanatory variables *X*.

However both can be suboptimal from a substantive perspective (no change over time).

More concerningly, they offer no ability to control for residual heterogeniety in the form of *unobserved time-invariant* explanatory variables.