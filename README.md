# FCS Analysis Pipeline

This repository contains a Snakemake workflow for analyzing FCS files. For each
input file the pipeline performs the following steps:

1. Selects channels with a non-empty description excluding scatter channels.
2. Applies an `asinh` transformation with cofactor 5.
3. Computes a 2D UMAP embedding.
4. Performs k-means clustering (5 clusters) in the original space (over the transformed channels).
5. Writes a new FCS file containing UMAP coordinates and cluster labels.
6. Generates a UMAP plot coloured by cluster.

The pipeline relies on the `flowCore` R package for parsing FCS files.

# Change log:
1) Fixed docker image creation and versions conflicts
2) Modified snakemake file to create directories 
3) Changed a command to run a container as: 
```
docker run --rm -v $(pwd):/data -w /data fcs_pipeline --cores 2
```
4) Added snakefile rule all part
5) Modified R script to accommodate channels from channels.txt.

For more information please check documentation.md file.

# Assignment task:
1) Make it work (build&run)
2) Add the possibility to input channels.txt and use only channels with 1 in the last column of channels.txt
3) It is not necessary to fix this repo (it is doable but might be tedious), feel free to implement the pipeline in 
the language of your choice.
4) The only conditions are: a) it must do what is described above, b) It must be runnable in docker container built
as part of the install process, c) the dependencies must transparently controlled (e.g. via conda environment 
yaml) and d) must run under pipelining sw (e.g. snakemake) which takes care of paralelisation and avoids 
recalculations of already processed files.
5) The result must be well documented


## Installation

Create a conda environment and install the dependencies:

```bash
conda env create -f environment.yml
conda activate fcs_pipeline
```

## Running the pipeline

Place your FCS files into `data/raw` and run:

```bash
snakemake --cores 4
```

Outputs will be written to `data/processed` and `plots`.

## Docker

Build a Docker image containing all dependencies:

```bash
docker build -t fcs_pipeline .
```

Run the pipeline using the image:

```bash
docker run --rm -v $(pwd):/data -w /data fcs_pipeline --cores 2
```

