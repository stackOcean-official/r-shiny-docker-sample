# r-shiny-docker-sample

Sample Deployment of a R Machine-Learning Model using Docker

## How to run

To start the training run:

```
Rscript src/train.R
```

## Docker

### How to build

```
docker build -t r-shiny-docker-sample .
```

### How to run

```
docker run --rm -p 8000:8000 r-shiny-docker-sample
```
