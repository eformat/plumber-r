# plumber-r

Run a R model container using [plumber](https://www.rplumber.io/index.html)

```bash
podman run --rm -p 8000:8000 quay.io/eformat/plumber-cars:latest
```

This one predict the miles per gallon based on car weight in pounds [model.R](model.R)

You can experiment with R and the model training [fit.R](fit.R) using the RStudio plumber image

```bash
podman run --rm -it -p 8000:8000 --entrypoint=R docker.io/rstudio/plumber:latest
```

Enter the commands from the R file.
