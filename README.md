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
FROM ghcr.io/gmel/docker:latest
```
