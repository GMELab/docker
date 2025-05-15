# GMEL Docker Container

This repository contains the standard Docker image for running analyses at GMEL.

## Installed Software
To request additional software, please send a message to Josef ([grafj1@mcmaster.ca](mailto:grafj1@mcmaster.ca)).
- Git
- R
  - lmutils
  - data.table
  - dplyr
  - mgcv
  - doParallel
  - foreach
  - MBESS
  - corpcor
- Python 3.13.2
  - numpy
  - pandas
  - matplotlib
- Rust
- lmutils
- PLINK

## Usage
The image is available on the GitHub Container Registry. It can be included in a Dockerfile as follows:

```Dockerfile
FROM ghcr.io/gmelab/docker:latest
```

## Docker Installation
To install Docker on your local machine, follow the instructions on the [Docker website](https://docs.docker.com/engine/install/).

## DNAnexus Usage

### As an environment
If we only want to run a single analysis, simply want to experiment, or just don't want to deal with Docker, we can use the Docker image as an environment on DNAnexus then run commands directly on it.

The simplest way is to simply specify the container ID in the `dx run` command. For example, if we want to run a simple R script, we can do so using the following command:

```bash
dx run swiss-army-knife \
  -iimage=ghcr.io/gmelab/docker:latest \
  -icmd='Rscript -e "print(\"Hello, World!\")"'
```

However, if your DNANexus project has no access to the internet, or you run into the GitHub Container Registry rate limits, you may want to download the Docker image and upload it to DNAnexus. This will allow you to run the analysis without needing to access the internet.

To do so, we first want to download and save the Docker image as an asset on DNAnexus.

```bash
docker pull ghcr.io/gmelab/docker:latest
# This might take a few minutes, and won't display a progress bar
docker save ghcr.io/gmelab/docker:latest | gzip | dx upload - --path docker-images/gmel-docker.tar.gz
```

Now, we can run commands inside our container!

```bash
dx upload - <<< 'print("Hello, World!")' --path analysis.R
dx run swiss-army-knife \
  -iimage_file=docker-images/gmel-docker.tar.gz \
  -iin="analysis.R" \
  -icmd='Rscript analysis.R'
```

### Building your own Docker Image
To run a reproducible analysis (i.e. something we may want to run dozens or hundreds of times), we want to extend the base Docker image with our analysis code and store it on DNAnexus.

To do so, we start by creating out Dockerfile.

```Dockerfile
FROM ghcr.io/gmelab/docker:latest

# This copies everything in the current directory to the container
# If we want to ignore certain files, we can create a .dockerignore file
COPY . .
```

Next, we want to build the Docker image. We can do this by running the following command in the directory with the Dockerfile:

```bash
docker build . -t my-analysis
```

Now that we have our Docker image, we want to push it as an asset to DNAnexus. We can do this using the following command:

```bash
# This might take a few minutes, and won't display a progress bar
docker save my-analysis | gzip | dx upload - --path docker-images/my-analysis.tar.gz
```

Finally, we can run the analysis using the following command:

```bash
dx run swiss-army-knife \
  -iimage_file=docker-images/my-analysis.tar.gz \
  -icmd='Rscript analysis.R'
```
