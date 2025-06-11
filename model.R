# load the model
model <- readRDS("my_fit.rds")

#* @get /hello
#* @serializer json
hello <- function(){
    return("Hello World")
}

#* @get /mpg
#* @serializer json
mpg <- function(weight){
    newcar = data.frame(wt=as.integer(weight))
    # predict the gas consumption
    return(predict(model, newcar))
}
