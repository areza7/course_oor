############################################################################

# restart the R session (Menu 'Session' - Restart R)

# read in data

load("data_survey_edit.rdata")

############################################################################

# stratified summary statistics / plots

by(dat$age, dat$sex, summary)
by(dat$age, dat$sex, mean)
by(dat$age, dat$sex, sd)

# by() combined with barplot() (PSS = Perceived Stress Scale)

by(dat$pss, dat$marital, mean)

by(dat$pss, dat$marital, mean, na.rm=TRUE)

barplot(by(dat$pss, dat$marital, mean, na.rm=TRUE),
        xlab="Marital Status", ylab="Mean PSS")

# horizontal

par(mar=c(5,9,4,2))

barplot(by(dat$pss, dat$marital, mean, na.rm=TRUE),
        xlab="Mean PSS", horiz=TRUE, las=1)

dev.off()

# if you want to add error bars to such a barplot, see here:
# https://www.r-graph-gallery.com/4-barplot-with-error-bar
# but also read: https://www.data-to-viz.com/caveat/error_bar.html
# barplots with error bars are usually not a good visualization technique

############################################################################

# boxplots
# https://en.wikipedia.org/wiki/Box_plot

boxplot(dat$pss ~ dat$marital)

boxplot(pss ~ marital, data=dat)

boxplot(pss ~ marital, data=dat, col="lightgray",
        xlab="Marital Status", ylab="PSS", pch=19, boxwex=0.6)

# 'boxwex' can be used to adjust the width of the boxes

# horizontal boxplot

par(mar=c(5,9,4,2))

boxplot(pss ~ marital, data=dat, col="lightgray",
        xlab="PSS", ylab="", pch=19, horizontal=TRUE, las=1,
        main="Perceived Stress by Marital Status", boxwex=0.6)

# something more colorful

boxplot(pss ~ marital, data=dat, col=rainbow(8),
        xlab="PSS", ylab="", pch=19, horizontal=TRUE, las=1,
        main="Perceived Stress by Marital Status", boxwex=0.6)

dev.off()

############################################################################

# stripchart (also called 'dot plot')
# https://en.wikipedia.org/wiki/Dot_plot_(statistics)

par(mar=c(5,9,4,2))

stripchart(pss ~ marital, data=dat, las=1, method="jitter", jitter=0.2,
           pch=19, cex=0.5, xlab="Perceived Stress Scale")

# combine boxplot with stripchart

boxplot(pss ~ marital, data=dat, col=rainbow(8,alpha=0.2),
        xlab="PSS", ylab="", pch=19, horizontal=TRUE, las=1,
        main="Perceived Stress by Marital Status", boxwex=0.6, range=0)

stripchart(pss ~ marital, data=dat, las=1, method="jitter", jitter=0.2,
           pch=19, cex=0.5, xlab="Perceived Stress Scale", add=TRUE,
           col=rainbow(8))

dev.off()

############################################################################

# violin plots
# https://en.wikipedia.org/wiki/Violin_plot

# install (if necessary) the 'vioplot' package and load it

if (!suppressWarnings(require(vioplot))) install.packages("vioplot")

library(vioplot)

# violin plots

par(mar=c(5,9,4,2))

vioplot(pss ~ marital, data=dat, horizontal=TRUE, las=1)

vioplot(pss ~ marital, data=dat, horizontal=TRUE, las=1, col=rainbow(8,alpha=0.2), ylab="")

stripchart(pss ~ marital, data=dat, las=1, method="jitter", jitter=0.2,
           pch=19, cex=0.5, xlab="Perceived Stress Scale", add=TRUE,
           col=rainbow(8))

dev.off()

############################################################################

# bean plots

# install (if necessary) the 'beanplot' package and load it

if (!suppressWarnings(require(beanplot))) install.packages("beanplot")

library(beanplot)

# beanplot

beanplot(pss ~ marital, data=dat, col="lightgray")

par(mar=c(5,9,4,2))

beanplot(pss ~ marital, data=dat, col=as.list(rainbow(8,alpha=0.2)),
         what=c(1,1,1,0), horizontal=TRUE, las=1)

stripchart(pss ~ marital, data=dat, las=1, method="stack", offset=0.2,
           pch=19, cex=0.5, xlab="Perceived Stress Scale", add=TRUE,
           col=rainbow(8))

dev.off()

############################################################################

# beeswarm plots

# install (if necessary) the 'beeswarm' package and load it

if (!suppressWarnings(require(beeswarm))) install.packages("beeswarm")

library(beeswarm)

# beeswarm

par(mar=c(5,9,4,2))

beeswarm(pss ~ marital, data=dat, horizontal=TRUE, las=1,
         xlab="Positive Affect", ylab="")

beeswarm(pss ~ marital, data=dat, horizontal=TRUE, las=1,
         xlab="Positive Affect", ylab="", pch=19, col=rainbow(8))

# combine boxplot with beeswarm

boxplot(pss ~ marital, data=dat, col=rainbow(8,alpha=0.2),
        xlab="PSS", ylab="", pch=19, horizontal=TRUE, las=1,
        main="Perceived Stress by Marital Status", boxwex=0.6, range=0)

beeswarm(pss ~ marital, data=dat, horizontal=TRUE, add=TRUE,
         pch=19, col=rainbow(8), cex=0.5)

dev.off()

############################################################################

# t-test

t.test(pss ~ sex, data=dat)

# note: this runs a t-test *not* assuming equal variances in the two groups
# (known as Welch's t-test): https://en.wikipedia.org/wiki/Welch's_t-test

# t-test assuming equal variances in the two groups (Student's t-test)

t.test(pss ~ sex, data=dat, var.equal=TRUE)

# visualize densities of the two groups

res.m <- density(dat$pss[dat$sex == "male"], na.rm = TRUE)
res.f <- density(dat$pss[dat$sex == "female"], na.rm = TRUE)

plot(res.m, xlab="Perceived Stress Scale Value", main="Kernel Density Estimates of Stress for Males and Females")
polygon(res.m, col=rgb(0,0,1,.2))
lines(res.f)
polygon(res.f, col=rgb(1,0,0,.2))
legend("topright", legend=c("Males", "Females"), fill=c(rgb(0,0,1,.2), rgb(1,0,0,.2)))

# try with a grouping variable that has more than 2 levels (error!)

t.test(pss ~ marital, data=dat)

############################################################################

# one-way ANOVA
# https://en.wikipedia.org/wiki/One-way_analysis_of_variance

res <- aov(pss ~ marital, data=dat)
res
summary(res)

# difference between means of all pairs of levels
# https://en.wikipedia.org/wiki/Tukey's_range_test

TukeyHSD(res)

############################################################################

# digression: testing all pairwise differences using Bonferroni correction

if (!suppressWarnings(require(multcomp))) install.packages("multcomp")

library(multcomp)

# turn 'marital' into a factor variable
dat$fmarital <- factor(dat$marital)

# fit model
res <- aov(pss ~ fmarital, data=dat)
summary(res)

# all pairwise comparisons using Bonferrroni correction
summary(glht(res, linfct = mcp(fmarital = "Tukey")), test = adjusted("bonferroni"))

############################################################################

# boxplot with two variables

boxplot(pss ~ sex * marital, data=dat, col="lightgray")

boxplot(pss ~ sex * marital, data=dat, col="lightgray", horizontal=TRUE)

par(mar=c(5,13,4,2))

boxplot(pss ~ sex * marital, data=dat, col="lightgray",
        xlab="PSS", ylab="", pch=19, horizontal=TRUE, las=1)

boxplot(pss ~ sex * marital, data=dat, col=rep(rainbow(8,alpha=0.4), each=2),
        xlab="PSS", ylab="", pch=19, horizontal=TRUE, las=1)

dev.off()

############################################################################

# two-way ANOVA with interaction
# https://en.wikipedia.org/wiki/Two-way_analysis_of_variance

res <- aov(pss ~ sex * marital, data=dat)
summary(res)

# two-way ANOVA with main effects only

res <- aov(pss ~ sex + marital, data=dat)
summary(res)

TukeyHSD(res)

# note: R (by default) computes Type I Sum of Squares (sequential tests), so
# the order how you specify the factors matters (while many other statistical
# software packages compute Type III Sum of Squares)

res <- aov(pss ~ marital + sex, data=dat)
summary(res)

############################################################################

# correlations
# https://en.wikipedia.org/wiki/Pearson_correlation_coefficient

# between two variables

cor(dat$posaff, dat$negaff)

# correlation matrix for multiple variables

cor(dat$posaff, dat$negaff, dat$pss)

cor(dat[c("posaff", "negaff", "pss")])

cor(dat[,c("posaff", "negaff", "pss")], use = "complete.obs")

round(cor(dat[,c("posaff", "negaff", "pss")], use = "complete.obs"), digits = 2)

# scatterplot for two variables

plot(dat$posaff, dat$negaff)

# correlation testing

cor.test(dat$posaff, dat$negaff)

# scatterplot matrix

pairs(dat[c("posaff", "negaff", "pss", "rses")])

pairs(dat[c("posaff", "negaff", "pss", "rses")], pch=19, cex=.1)

pairs(dat[c("posaff", "negaff", "pss", "rses")], pch=19, cex=.1,
      col=ifelse(dat$sex == "male", "blue", "red"))

# Spearman correlation
# https://en.wikipedia.org/wiki/Spearman's_rank_correlation_coefficient

cor(dat$posaff, dat$negaff, method="spearman")

############################################################################

# linear regression
# https://en.wikipedia.org/wiki/Linear_regression

# scatterplot of age (x-axis) versus stress (y-axis)

plot(dat$age, dat$pss, pch=19)

# can also use 'formula syntax'

plot(pss ~ age, data=dat, pch=19)

# simple regression of stress (outcome) on age (predictor)

res <- lm(pss ~ age, data=dat)
res

summary(res)

# add regression line to the plot above (lwd is for the line width)

abline(res, lwd=3)

# fitted values, residuals, standarized residuals

fitted(res)
residuals(res)
rstandard(res)

# fitted values versus residuals plot

plot(fitted(res), residuals(res), pch=19,
     xlab="Fitted Values", ylab="Residuals")

abline(h=0)

# normal Q-Q plot of standardized residuals
# https://en.wikipedia.org/wiki/Q–Q_plot

qqnorm(rstandard(res), pch=19)
qqline(rstandard(res))

# plot of the Cook's distances
# https://en.wikipedia.org/wiki/Cook's_distance

plot(cooks.distance(res), pch=19, type="o", ylab="Cook's Distance")

# identify the potentially influential subjects

which(cooks.distance(res) > 0.03)

plot(pss ~ age, data=dat, pch=19)
abline(res, lwd=3)
points(pss ~ age, data=dat, subset=c(68,77), col="red", pch=19, cex=2)

# install (if necessary) and load the 'car' package

if (!suppressWarnings(require(car))) install.packages("car")

library(car)

# a nicer Q-Q plot

qqPlot(res, pch=19, cex=0.5, reps=5000)

plot(pss ~ age, data=dat, pch=19)
abline(res, lwd=3)
points(pss ~ age, data=dat, subset=c(10,19), col="red", pch=19, cex=2)

# just to illustrate an extreme case

tmp <- dat
tmp$age[1] <- 80
tmp$pss[1] <- 45

plot(pss ~ age, data=tmp, pch=19)
res <- lm(pss ~ age, data=tmp)
abline(res, lwd=3)

plot(cooks.distance(res), pch=19, type="o", ylab="Cook's Distance")

############################################################################

# digression: Type III tests with the 'car' package

res <- aov(pss ~ sex + marital, data=dat)

# sequential tests

summary(res)

# get the marginal tests (Anova() function comes from the 'car' package)

Anova(res, type=3)

# to compare

summary(aov(pss ~ sex + marital, data=dat))
summary(aov(pss ~ marital + sex, data=dat))

############################################################################

# refit the regression model

res <- lm(pss ~ age, data=dat)
summary(res)

plot(pss ~ age, data=dat, pch=19)

coef(res)

# computing predicted values

# the manual way: adding a line based on the predicted values

xvals <- 10:90
xvals
yvals <- coef(res)[1] + coef(res)[2] * xvals
yvals

lines(xvals, yvals, lwd=3)

# using the predict() function

# first create a data frame with the same predictor(s) as used in the model

newdat <- data.frame(age = 10:90)

# now can use the predict() function with 'newdata'

predict(res, newdata=newdat)

# this is useful because predict() can also give us additional information

predict(res, newdata=newdat, interval="confidence")

# save this to an object

pred <- predict(res, newdata=newdat, interval="confidence")
head(pred)

# now add the line to the plot

plot(pss ~ age, data=dat, pch=19)
lines(newdat$age, pred$fit, lwd=3)

# what?!? (error messages in R are sometimes super informative ...)

# predict() doesn't return a data frame, but a matrix (which is similar to a
# data frame, but a matrix cannot contain a mix of numerical and character
# variables and one cannot use the $ notation to extract elements)

# this works

pred[,"fit"]

# or we can turn the matrix into a data frame

pred <- as.data.frame(pred)
head(pred)

# now this works (lty is for the line type)

lines(newdat$age, pred$fit, lwd=3)
lines(newdat$age, pred$lwr, lty="dashed")
lines(newdat$age, pred$upr, lty="dashed")

# also add the prediction interval

pred <- predict(res, newdata=newdat, interval="prediction")
pred <- as.data.frame(pred)

lines(newdat$age, pred$lwr, lty="dotted")
lines(newdat$age, pred$upr, lty="dotted")

# https://en.wikipedia.org/wiki/Prediction_interval#Regression_analysis

############################################################################

# transformation of the outcome variable

res <- lm(negaff ~ age, data=dat)
summary(res)

# fitted values versus residuals plot

plot(fitted(res), residuals(res), pch=19,
     xlab="Fitted Values", ylab="Residuals")
abline(h=0)

plot(jitter(fitted(res), amount=0.5), jitter(residuals(res), amount=2),
     pch=19, xlab="Fitted Values", ylab="Residuals")
abline(h=0)

# normal Q-Q plot of standardized residuals

qqnorm(rstandard(res), pch=19)
qqline(rstandard(res))

# histogram of the outcome variable

hist(dat$negaff)

# histogram of the standardized residuals

hist(rstandard(res))

# histogram of the log-transformed outcome variable

hist(log(dat$negaff))

# fit model with log-transformed outcome

res <- lm(log(negaff) ~ age, data=dat)
summary(res)

# normal Q-Q plot of standardized residuals

qqnorm(rstandard(res), pch=19)
qqline(rstandard(res))

# plot data and model fit

plot(log(negaff) ~ age, data=dat, pch=19)

newdat <- data.frame(age = 10:90)
pred <- predict(res, newdata=newdat)
lines(newdat$age, pred, lwd=3)

# back-transform the outcome and predicted values

plot(negaff ~ age, data=dat, pch=19)
lines(newdat$age, exp(pred), lwd=3)

############################################################################

# polynomial regression
# https://en.wikipedia.org/wiki/Polynomial_regression

set.seed(1234)
plot(jitter(dat$negaff, amount=.5), jitter(dat$pss, amount=.5), pch=19,
     xlab="Negative Affect", ylab="Perceived Stress")

res <- lm(pss ~ negaff, data=dat)
summary(res)

abline(res, lwd=3)

res <- lm(pss ~ negaff + I(negaff^2), data=dat)
summary(res)

# the manual way

xvals <- 0:50
xvals
yvals <- coef(res)[1] + coef(res)[2] * xvals + coef(res)[3] * xvals^2
yvals

lines(xvals, yvals, col="red", lwd=3)

# using predict()

newdat <- data.frame(negaff = 0:50)
predict(res, newdata=newdat)

# note: the predict() function applies the same transformations we used when
# we specified the model

pred <- predict(res, newdata=newdat)
lines(newdat$negaff, pred, col="red", lwd=3)

############################################################################

# multiple regression

res <- lm(pss ~ age + rses, data=dat)
summary(res)

res <- lm(pss ~ age + rses + age:rses, data=dat)
summary(res)

res <- lm(pss ~ age * rses, data=dat)
summary(res)

# note: var1 * var2 is a shortcut for adding the main effects of var1 and
# var2 and also their interaction (i.e., var1:var2)

############################################################################

# categorical predictors

res <- lm(pss ~ sex, data=dat)
summary(res)

res <- lm(pss ~ marital, data=dat)
summary(res)

# variables 'sex' and 'marital' are character variables

dat$marital

# character variables are turned into factors when they are used as predictor
# variables; and factors are 'dummy coded' when used as predictors; the first
# level of a factor is (by default) the one that comes first alphanumerically

# we can manually turn a variable into a factor

factor(dat$marital)

# and we can 'relevel' a factor to choose the reference level

relevel(factor(dat$marital), ref="single")

# as always, need to back-assign to make this change permanent

dat$marital <- relevel(factor(dat$marital), ref="single")

# check levels of factor variable

levels(dat$marital)

res <- lm(pss ~ marital, data=dat)
summary(res)

############################################################################

# numerical and categorical predictors in the same model

res <- lm(pss ~ sex + negaff, data=dat)
summary(res)

# note: this is the same as an analysis of covariance (ANCOVA)
# https://en.wikipedia.org/wiki/Analysis_of_covariance

# with interaction

res <- lm(pss ~ sex * negaff, data=dat)
summary(res)

# plot results

set.seed(9876)
plot(jitter(pss, amount=0.5) ~ jitter(negaff, amount=0.5), data=dat,
     xlab="Stress", ylab="Negative Affect",
     main="Relationship Between Stress and Negative Affect",
     pch=19, xlim=c(10,50), ylim=c(10,50),
     col=ifelse(dat$sex == "female", "red", "blue"), cex=0.5)

# using predict() to add regression line for the males and females

range(dat$negaff)

newdat <- data.frame(sex = "male", negaff=0:50)
newdat
pred <- predict(res, newdata=newdat)
pred

lines(newdat$negaff, pred, lwd=3, col="blue")

newdat <- data.frame(sex = "female", negaff=0:50)
pred <- predict(res, newdata=newdat)

lines(newdat$negaff, pred, lwd=3, col="red")

# add a legend

legend("topleft", legend=c("female","male"), col=c("red","blue"),
       pch=c(19,19), lty=c("solid", "solid"), inset=.02)

############################################################################

# smoothers

set.seed(4321)
plot(jitter(dat$negaff, amount=.5), jitter(dat$pss, amount=.5), pch=19,
     xlab="Negative Affect", ylab="Perceived Stress")

res <- lm(pss ~ negaff + I(negaff^2), data=dat)
summary(res)

newdat <- data.frame(negaff = 0:50)
pred <- predict(res, newdata=newdat)
lines(newdat$negaff, pred, col="red", lwd=3)

# loess = locally estimated scatterplot smoothing
# - provides a non-parametric estimate of the relationship between x and y
# - https://en.wikipedia.org/wiki/Local_regression

res <- loess(pss ~ negaff, data=dat)
summary(res)

pred <- predict(res, newdata=newdat)
lines(newdat$negaff, pred, col="blue", lwd=3)

# adjust the 'span' argument (default is 0.75; lower means less smoothing)

res <- loess(pss ~ negaff, data=dat, span=0.4)
pred <- predict(res, newdata=newdat)
lines(newdat$negaff, pred, col="green", lwd=3)

legend("bottomright", inset=.02, col=c("red","blue","green"),
       legend=c("2nd Degree Polynomial","Smoother (span = 0.75)","Smoother (span = 0.40)"),
       lty="solid", lwd=3)

# Friedman's 'super smoother' ('bass' controls the degree of smoothing)

res <- supsmu(dat$negaff, dat$pss, bass=5)
res

lines(res$x, res$y, col="orange", lwd=3)

############################################################################

# add an approximate 95% CI to the loess smoother

plot(jitter(dat$negaff, amount=.5), jitter(dat$pss, amount=.5), pch=19,
     xlab="Negative Affect", ylab="Perceived Stress")
res <- loess(pss ~ negaff, data=dat)
newdat <- data.frame(negaff = 0:50)
pred <- predict(res, newdata=newdat, se=TRUE)
lines(newdat$negaff, pred$fit, col="blue", lwd=3)
lines(newdat$negaff, pred$fit-1.96*pred$se, col="blue", lwd=3, lty="dotted")
lines(newdat$negaff, pred$fit+1.96*pred$se, col="blue", lwd=3, lty="dotted")

############################################################################
