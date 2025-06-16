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
# if x is not a factor it will produce a scatter plot
plot(mtcars$cyl, mtcars$mpg)
# boxplot of mpg
boxplot(mtcars$mpg)
# boxplot of mpg by cyl
boxplot(mpg ~ cyl, data = mtcars)
