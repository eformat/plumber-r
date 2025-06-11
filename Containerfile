FROM docker.io/rstudio/plumber:latest
COPY my_fit.rds my_fit.rds
COPY model.R plumber.R
CMD [ "/plumber.R" ]
