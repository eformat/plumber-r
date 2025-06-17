# https://uc-r.github.io/quickplots
# plotting package
library(ggplot2)
# read dataset motorcars
data(mtcars)
head(mtcars)
# mpg vs weight plot
plot(x = mtcars$wt, y = mtcars$mpg)
# histogram
hist(mtcars$mpg)
hist(mtcars$mpg, breaks = 10)
qplot(mtcars$mpg, binwidth = 3, color = I("white"))
# boxplot of mpg by cyl
boxplot(mpg ~ cyl, data = mtcars)
# boxplot of mpg based on interaction of two variables
boxplot(mpg ~ cyl + am, data = mtcars)
# boxplot of mpg
boxplot(mtcars$mpg)
