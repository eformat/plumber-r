#* @get /mean
normalMean <- function(samples=10){
  data <- rnorm(samples)
  mean(data)
}

#* @post /sum
addTwo <- function(a, b){
  as.numeric(a) + as.numeric(b)
}

#* @post /subtract
addTwo <- function(a, b){
  as.numeric(a) - as.numeric(b)
}
