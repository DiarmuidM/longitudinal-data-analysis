# Panel Data Analysis I

In this section we define the general methodological and substantive issues associated with panel data.

We conclude with a consideration of the key questions a researcher should ask before undertaking analysis of panel data. 

## Introduction

The analysis of repeated contacts data is known as **panel data analysis**. 

Recall that repeated contacts data captures information on your units of analysis more than once. As a result, observations are *nested* or *clustered* within units e.g., observations of pupils' exam results are nested within schools.

## Methodological implications of panel data

The use of panel data implies the potential for the violation of an important regression assumption: error terms are independent of each other (Mehmetoglu & Jakobsen, 2016)

In panel data a unit's own observations are often *interdependent*, meaning they are more likely to be similar to each other than the observations for other units in the panel.

### Independence of error term

Recall one of the core assumptions of linear regression:

$$\text{cov(}\epsilon{, X)=0}$$

The variation in our outcome that is left unexplained ($\epsilon$) should not be correlated with any of the explanatory variables in the model.

If the covariance is **not equal** to zero, then the observations for each unit *i* are *serially correlated*, a circumstance also known as *autocorrelation*. 

What this means in practice is the value of a variable at time *t* predicts the value of the same variable at time *t + k* for a given unit *i* (where *k* represents another time period in which unit *i* is observed).

Autocorrelation can give rise to *heteroscedasticity*, which very often results in the under-estimation of standard errors in regression models.

It can also lead to the much more serious issue of biased coefficients.

### Summary of issues

Panel data contain observations nested within units.

The interdependence of observations often violates a key assumption of linear regression (*independence of errors*).

Ignoring this interdependence when estimating your statistical model can lead to two problems:
1. Under-estimation of the uncertainty surrounding the coefficients (*inefficiency*).
2. Incorrect estimates of the coefficients (*bias*).

Inefficiency leads to under-estimated standard errors and potential false positive tests of statistical significance.

Bias leads to incorrect inferences about the magnitude and direction of the effects of the explanatory variables in your model.

## Methodological benefits of panel data

Hold on, this entire training course is predicated on there being some advantage to using panel data over cross-sectional data!

Correct, and here it is...

The problem of **inefficient estimates** can at least be ameliorated when using cross-sectional data (e.g., robust or clustered standard errors).

The problem of **biased coefficients** is very difficult to solve when using cross-sectional data.

This because it is very difficult to find a data set that contains all of the explanatory variables you need for your model --> omitted variable bias.

Let's see what happens when omitted variable bias is present; that is, we have not specified the model correctly:

clear
capture set seed 1010
quietly set obs 10000

gen x1 = rnormal(1, 20)
gen x2 = x1 + rnormal(1, 10)
gen eterm = rnormal()
gen y = 2 + x1 + x2 + eterm
l y x1 x2 in 1/10

First, we estimate a properly specified model:

regress y x1 x2

Now let's estimate a model that excludes one of the explanatory variables:

regress y x1

Notice how the coefficient for `x1` has been inflated? This is because `x1` and `x2` are correlated (by definition), and therefore `x1` "soaks up" some of the variation in `y` that is explained by `x2` (Gelman and Hill, 2007).

corr x1 x2
corr y x2

### So why panel data?

As the simple example above demonstrates, one way of solving omitted variable bias is to include the omitted explanatory variable(s)!

This can be difficult to achieve in practice, as many of these variables may not be captured by the data set, or even possible to record at all (Mehmetoglu & Jakobsen, 2016).

If certain assumptions hold, the use of panel data allow us to control for the influence of any omitted variables on the coefficients of the explanatory variables.

**Key assumption:** the omitted variables are *time-invariant*.

> As long as we make the assumption that (at least some of) these effects are enduring there are techniques for accounting for omitted explanatory variables if we have data at more than one time point. (Gayle, 2018)

Panel data won't completely address this problem, but suitable models can improve control for, and even estimate the effects of, omitted explanatory variables.

## Substantive benefits of panel data

It would be unwise to focus exclusively on the methodological implications of panel data.

A major advantage of such data sets is their ability to capture social processes as they evolve over time (*micro-level change*).

import delimited using "../data/lda-employed-example-2020-08-28.csv", clear varn(1)
tab pid employed

In this fictional example we see that the two individuals have the same overall employment history: five periods of employment, five of unemployment.

However this summary masks the stark difference in their employment trajectories:

l

Individual `10001` drifts in and out of employment, while `10025` only changes employment status once (in 2005).

Therefore we can decide to focus on analysing change over time, in addition to traditional analyses of differences between groups: 

xtset pid year
bys pid: xttrans employed

## Panel data analysis: key considerations

How can we use our understanding of these two advantages of panel data &mdash; **examining micro-level change** and **improved control for residual heterogeneity** &mdash; when estimating statistical models? 

A good approach is to pose two overarching questions:

### How do your explanatory variables influence the outcome?

* Are you interested in how *changes within units* are associated with variation in the outcome?
* Are you interested in how *differences between units* are associated with variation in the outcome?
* Both?

Consider this simple example:

Would you expect the effect of retirement on income to differ whether: 
* we were comparing two individuals (one retired, one not), or 
* we were comparing one individual who changes retirement status between two time periods?

Here is another example:

Average earnings in the Outer Hebrides of Scotland are lower than average for London. But would we expect earnings to drop on average if someone moves from London to the Outer Hebrides?

![Outer Hebrides](./images/oh-map.jpg)

Credit: [Wikipedia](https://en.wikipedia.org/wiki/Outer_Hebrides)

Answering the question &mdash; *how do your explanatory variables influence the outcome?* &mdash; requires theoretical insight on the nature of the relationships between your explanatory factors and outcome of interest. The decision you make influences which type of panel data model you ultimately select as being most appropriate for your research question.

### Is your statistical model specified correctly?

Do you have all and only relevant explanatory variables in your model (Gelman and Hill, 2007)?

How worried are you that some (especially important) explanatory variables have not been included in your model?

Do you think the omission of these explanatory variables is leading to bias in the variables included in the model?

This is a technical issue and there are a number of statistical tests and techniques that can help guide us to select the most appropriate panel data model.

## Task

Think of a piece of quantitative analysis you have done (or would like to do).

Clearly state the analysis in terms of an outcome and a set of explanatory variables (a statistical model).

Consider the two main questions:
* *How does each of your explanatory variables influence the outcome?*
* *Is your statistical model specified correctly?*

Finally, consider whether and how panel data would support the estimation of your statistical model.