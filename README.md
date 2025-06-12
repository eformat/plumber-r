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

## RStudio build for RHOAI

Good instructions are here:

- https://developers.redhat.com/articles/2024/06/06/how-integrate-and-use-rstudio-server-openshift-ai#setting_up_rstudio_server_on_openshift_ai

Checkout available BuildConfig's

```bash
oc get bc -n redhat-ods-applications 

cuda-rhel9                  Docker   Git@rhoai-2.19   0
cuda-rstudio-server-rhel9   Docker   Git@rhoai-2.20   0
rstudio-server-rhel9        Docker   Git@rhoai-2.20   0
```

Create your RHN secret

```bash
oc -n redhat-ods-applications \
    create secret generic rhel-subscription-secret \
    --from-literal=USERNAME=your-rhn-user-name \
    --from-literal=PASSWORD=your-rhn-password
```

Start build, wait for completion

```bash
oc -n redhat-ods-applications  start-build rstudio-server-rhel9
```

Tag ImageStream for use in jupyter as notebook

```bash
oc label imagestream rstudio-rhel9 opendatahub.io/notebook-image='true' -n redhat-ods-applications
```

## ModelCar deployment using SingleModel KServe runtime

Build the server runtime pod

```bash
podman build -t quay.io/eformat/plumber-runtime:latest -f Containerfile.plumber-runtime
podman push quay.io/eformat/plumber-runtime:latest
```

Build the mcars R application model pod

```bash
podman build -t quay.io/eformat/mcars-plumber:latest -f Containerfile.mcars-plumber
podman push quay.io/eformat/mcars-plumber:latest
```

Deploy ServingRuntime template to RHOAI

```bash
oc apply -f rplumber-runtime-template.yaml
```

Deploy application model-car to RHOAI

```bash
oc apply -f serving-mcars-rplumber.yaml
```

## Test

Successful deployment should see R model being served up OK

```bash
+ mcars-rplumber-predictor-c45999fbd-jr49f › modelcar
+ mcars-rplumber-predictor-c45999fbd-jr49f › kserve-container
mcars-rplumber-predictor-c45999fbd-jr49f kserve-container ARGUMENT '~/plumber.R' __ignored__
mcars-rplumber-predictor-c45999fbd-jr49f kserve-container 
mcars-rplumber-predictor-c45999fbd-jr49f kserve-container 
mcars-rplumber-predictor-c45999fbd-jr49f kserve-container R version 4.5.0 (2025-04-11) -- "How About a Twenty-Six"
mcars-rplumber-predictor-c45999fbd-jr49f kserve-container Copyright (C) 2025 The R Foundation for Statistical Computing
mcars-rplumber-predictor-c45999fbd-jr49f kserve-container Platform: x86_64-pc-linux-gnu
mcars-rplumber-predictor-c45999fbd-jr49f kserve-container 
mcars-rplumber-predictor-c45999fbd-jr49f kserve-container R is free software and comes with ABSOLUTELY NO WARRANTY.
mcars-rplumber-predictor-c45999fbd-jr49f kserve-container You are welcome to redistribute it under certain conditions.
mcars-rplumber-predictor-c45999fbd-jr49f kserve-container Type 'license()' or 'licence()' for distribution details.
mcars-rplumber-predictor-c45999fbd-jr49f kserve-container 
mcars-rplumber-predictor-c45999fbd-jr49f kserve-container   Natural language support but running in an English locale
mcars-rplumber-predictor-c45999fbd-jr49f kserve-container 
mcars-rplumber-predictor-c45999fbd-jr49f kserve-container R is a collaborative project with many contributors.
mcars-rplumber-predictor-c45999fbd-jr49f kserve-container Type 'contributors()' for more information and
mcars-rplumber-predictor-c45999fbd-jr49f kserve-container 'citation()' on how to cite R or R packages in publications.
mcars-rplumber-predictor-c45999fbd-jr49f kserve-container 
mcars-rplumber-predictor-c45999fbd-jr49f kserve-container Type 'demo()' for some demos, 'help()' for on-line help, or
mcars-rplumber-predictor-c45999fbd-jr49f kserve-container 'help.start()' for an HTML browser interface to help.
mcars-rplumber-predictor-c45999fbd-jr49f kserve-container Type 'q()' to quit R.
mcars-rplumber-predictor-c45999fbd-jr49f kserve-container 
mcars-rplumber-predictor-c45999fbd-jr49f kserve-container > pr <- plumber::plumb(rev(commandArgs())[1]); args <- list(host = '0.0.0.0', port = 8000); if (packageVersion('plumber') >= '1.0.0') { pr$setDocs(TRUE) } else { args$swagger <- TRUE }; do.call(pr$run, args)
mcars-rplumber-predictor-c45999fbd-jr49f kserve-container Running plumber API at http://0.0.0.0:8000
mcars-rplumber-predictor-c45999fbd-jr49f kserve-container Running swagger Docs at http://127.0.0.1:8000/__docs__/
```

Call the R model to predict the miles per gallon for a 5000 lb car

```bash
 curl -X 'GET' 'https://mcars-rplumber-predictor-llama-serving.apps.sno.sandbox1005.opentlc.com/mpg?weight=5' -H 'accept: application/json'
[10.5628]
```
