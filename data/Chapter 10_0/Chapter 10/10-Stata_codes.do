//do-file for "Panel data analysis"
//use BritishHouseholdPanel.dta

xtset id year

tab year
xtdescribe

reg mental age woman couple separated divorced never_married  // simple regression

net sj 3-2 st0039
net install st0039  //installs Wooldridge's test for autocorrelation

xtserial mental age woman couple separated divorced never_married  // runs Wooldridge's test for autocorrelation in panel data

quietly reg mental age woman couple separated divorced never_married
predict Pmental
gen Rmental=mental-Pmental
scatter Rmental Pmental //graphs the residuals against the fitted values

hettest //Breusch-Pagan/Cook-Weisberg test for heteroskedasticity

regress mental age woman couple separated divorced never_married, vce(cluster id) // regression using the robust and cluster options

quietly regress mental age woman couple separated divorced never_married
collapse (mean) mental age woman couple separated divorced never_married if e(sample), by(id)  // this alters the data structure
regress mental age woman couple separated divorced never_married // between effects model

xtreg mental age woman couple separated divorced never_married, be // between effects model without altering the data structure

quietly xtreg mental age woman couple separated divorced never_married, fe
estimates store fixed
quietly xtreg mental age woman couple separated divorced never_married, re
estimates store random
hausman fixed random // Hausman test for model efficiency


//use Happiness.dta

generate Dbob=id==1 if !missing(id)
generate Dsarah=id==2 if !missing(id)
generate Dpeter=id==3 if !missing(id)
generate Dnicole=id==4 if !missing(id)

regress happiness Dsarah Dpeter Dnicole income1000

gen Bob = -4.107029 + 0.0824934*income1000
gen Sarah = -4.107029 + 5.111141 + 0.0824934
gen Peter = -4.107029 + 4.226857 + 0.0824934
gen Nicole = -4.107029 + 9.410411 + 0.0824934
graph twoway line Bob income1000 || line Sarah income1000 || line Peter income1000 || line Nicole income1000 // fixed effects model 

reg happinessDm income1000DM // analogous fixed effects model

reg happiness income1000 // simple regression

xtset id
xtreg happiness income1000, fe // fixed effects model


//use BritishHouseholdPanel.dta

xtset id
xtreg mental age woman couple separated divorced never_married, fe // fixed effects model

xtset year
xtreg menat age woman couple separated divorced never_married, fe // time fixed effects

xtset id
xtreg mental age woman couple separated divorced never_married, re // random effects


//use TimeSeriesCrossSection.dta

tsset cow year

tab cow
duplicates report cow year  // reports duplicates
duplicates list cow year
duplicates tag cow year, gen(isdup)
edit if isdup

sum FDI, detail

gen lnFDI=ln(FDI) // generating log transformed variable
sum lnFDI, detail

graph twoway line lnFDI year if cow<100
graph twoway line lnFDI year if cow>=100 & cow<200
graph twoway line lnFDI year if cow>=200 & cow<300
graph twoway line lnFDI year if cow>=300 & cow<400
graph twoway line lnFDI year if cow>=400 & cow<500
graph twoway line lnFDI year if cow>=500 & cow<600
graph twoway line lnFDI year if cow>=600 & cow

dfuller lnFDI if cow==20, lags(1)  // Dickey-Fuller test
dfuller lnFDI if cow==20, lags(1), regress

corrgram lnFDI if cow==20, lags(10)

ac lnFDI if cow==20, lags(10)

regress lnFDI l.lnFDI l.GDPperCapita l.GDPGrowth ethfrac l.incidence, vce(cluster cow) // regression 

tab onset2

logit onset2 l.GDPGrowth l.GDPperCapita ethfrac, vce(cluster cow) // Logistic regression

xtlogit onset2 l.GDPGrowth l.GDPperCapita ethfrac  // random effects logit model

tab onset2 if e(sample)

logit onset2 l.incidence l.GDPGrowth l.GDPperCapita ethfrac, vce(cluster cow)

//use btscs.ado

bstsc incidence year cow, g(peaceyears) nspline(3)
logit onset2 peaceyears _spline1 _spline2 _spline3 l.GDPGrowth l.GDPperCapita ethfrac, vce(cluster cow)  // logit regression using peaceyears with splines
















