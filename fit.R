# read dataset motorcars
data(mtcars)
head(mtcars)
# build a regression model for miles per gallon against weight
fit = lm(mpg ~ wt, mtcars)
summary(fit)
# save model
saveRDS(fit, file = "my_fit.rds")
# reset and load
rm(fit)
fit <- readRDS("my_fit.rds")
fit
# This model predicts a gas mileage for each of our existing cars
predict(fit)
# new car weighing 4500 pounds
newcar = data.frame(wt=4.5)
# predict the gas consumption
predict(fit, newcar)