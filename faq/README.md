# Longitudinal Data Analysis

## Frequently Asked Questions

The following is a sample of questions that have been posed during the *Longitudinal Data Analysis for Social Scientists* one-day course.

### Q. Could you briefly clarify the difference between the terms ‘estimator’ and ‘model’?
The terms are often used interchangeably (Fixed Effects Model / Estimator) but there are differences:
* A *model* is the equation / function that links an outcome to a set of explanatory factors. For example, the linear regression model predicts a numeric outcome as a linear function of a set of explanatory variables.
* An *estimator* is the rule / algorithm / calculation that produces the estimates (coefficients) of the parameters in a model. For example, Ordinary Least Squares (OLS) is the standard estimator behind the linear regression model.

### Q. How do I arrange my data for longitudinal data analysis?
Typically you would arrange your data in **long format**: multiple rows per unit of analysis, with each row uniquely identified by a combination of `uniqueid` and `time`:

| Name       | Year | Income |
|------------|------|--------|
| John Smith | 2015 | £25000 |
| John Smith | 2016 | £25000 |
| John Smith | 2017 | £30000 |

Stata requires your data to be in long format in order to estimate panel data models (e.g., Random Effects). You could also arrange your data in **wide format**: one row per unit of analysis, with multiple variables capturing the value over time:

| Name       | Income_2015 | Income_2016 | Income_2017 |
|------------|-------------|-------------|-------------|
| John Smith | £25000      | £25000      | £30000      |

Wide format can be useful for descriptive analysis and visually inspecting data, but long format is the prefered (and often necessary) data structure.

### Q. What do the various R-squared results mean in a panel data model?
R-squared &mdash; also known as the *coefficient of determination* &mdash; measures the proportion of variance in the outcome that is accounted for by the explanatory variables in your model. It is a measure of how well your model 'fits' the data i.e., how well can we predict the outcome using our knowledge of the explanatory variables.

In Stata, three different R-squared measures are produced when you estimate a panel data model (e.g., Fixed / Random / Between Effects):
* *within* = measures the proportion of *within* variance in the outcome that is accounted for by the explanatory variables in your model. That is, when we only consider variation within units of analysis (i.e., over time), how well does the model fit the data?
* *between* = measures the proportion of *between* variance in the outcome that is accounted for by the explanatory variables in your model. That is, when we only consider variation between or across units of analysis (i.e., differences between units), how well does the model fit the data?
* *overall* = measures the proportion of *total* variance in the outcome that is accounted for by the explanatory variables in your model. That is, when we consider all of the variation in the outcome (i.e., between units **and** over time), how well does the model fit the data?

### Q. Can rho be understood as 1 - R squared?
No but you are thinking along the correct lines. R-squared measures the proportion of variance in the outcome that is accounted for by the explanatory variables in your model. Therefore the proportion of *unexplained* variance = 1 - R-squared. Of this unexplained variance, *rho* captures the proportion that is accounted for by the unit-specific effects in a Fixed / Random Effects model.

### Q. How is autocorrelation different from multicollinearity?
These terms represent the same statistical property &mdash; correlation &mdash; but in different contexts. *Autocorrelation* is a measure of the correlation between a variable and its past values e.g., is my income this year correlated with my income last year (or previous years)? *Multicollinearity* captures the correlation between the values of a set of variables (typically those included in a regression model) e.g., are age, income and sex correlated (and to what extent)?