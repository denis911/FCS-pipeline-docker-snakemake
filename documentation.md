  
## Overview

This repository contains a Dockerized Snakemake workflow for processing Flow Cytometry Standard (FCS) files. The pipeline performs UMAP clustering and generates visualization plots for flow cytometry data analysis.

## Features

- **Containerized workflow**: Uses Docker for reproducible environments
- **Automated processing**: Processes multiple FCS files in batch
- **UMAP clustering**: Performs dimensionality reduction and clustering
- **Visualization**: Generates plots for each processed sample
- **Scalable**: Configurable number of CPU cores for parallel processing

## Prerequisites

- Docker installed on your system
- FCS data files
- Basic familiarity with command line operations

## Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/denis911/FCS-pipeline-docker-snakemake.git
cd FCS-pipeline-docker-snakemake
```

### 2. Prepare Your Data
Place your `.fcs` files in the `data/raw` directory:
```
data/
├── raw/
│   ├── sample1.fcs
│   ├── sample2.fcs
│   └── ...
├── processed/
└── plots/
```

### 3. Configure the Pipeline
Edit `config.yaml` to match your setup:
```yaml
raw_dir: "data/raw"
processed_dir: "data/processed"
plot_dir: "plots"
n_clusters: 5
```

### 4. Run the Pipeline
```bash
docker run --rm -v $(pwd):/data -w /data fcs_pipeline --cores 2
```

**Note**: The Docker image has an `ENTRYPOINT` configured for Snakemake, so you don't need to specify `snakemake` in the command.

## Troubleshooting

### Common Issues and Solutions

#### 1. "No rule to produce snakemake" Error
**Problem**: This error typically occurs when `snakemake` is included in the Docker command.

**Solution**: The Docker image has `ENTRYPOINT ["/opt/conda/envs/fcs_pipeline/bin/snakemake"]` configured. Use:
```bash
docker run --rm -v $(pwd):/data -w /data fcs_pipeline --cores 2
```
**Not**:
```bash
docker run --rm -v $(pwd):/data -w /data fcs_pipeline snakemake --cores 2
```

#### 2. "No Snakefile found" Error
**Problem**: Snakemake cannot locate the Snakefile.

**Solutions**:
- Ensure your file is named exactly `Snakefile` (capital S, no extension)
- Check that you're mounting the correct directory with `-v`
- Verify the working directory with `-w /data`

#### 3. Path Issues with File Names Containing Spaces
**Problem**: FCS files with spaces in names can cause shell command issues.

**Solution**: The pipeline handles this by using quoted paths in shell commands:
```python
shell:
    'Rscript "{workflow.basedir}/scripts/process_fcs.R" -i "{input}" -o "{output.fcs}" -p "{output.plot}"'
```

#### 4. Volume Mounting Issues
**Problem**: Files not visible inside the container.

**Solution**: Ensure correct volume mounting:
```bash
# Windows
docker run --rm -v C:\path\to\your\project:/data -w /data fcs_pipeline --cores 2

# Linux/Mac
docker run --rm -v /path/to/your/project:/data -w /data fcs_pipeline --cores 2
```

## Configuration Options

### config.yaml Parameters
- `raw_dir`: Directory containing input FCS files
- `processed_dir`: Directory for processed output files  
- `plot_dir`: Directory for generated plots
- `n_clusters`: Number of clusters for analysis (default: 5)

### Docker Command Parameters
- `--rm`: Automatically remove container when it exits
- `-v`: Volume mount (host:container)
- `-w`: Working directory inside container
- `--cores N`: Number of CPU cores to use

## Current Limitations and Future Improvements

### Known Issues
- **R Script Dependencies**: Some R package dependencies may require updates for optimal compatibility with newer systems
- **Large File Handling**: Very large FCS files (>1GB) may require memory optimizations
- **Error Reporting**: R script error messages could be more descriptive for debugging

### Planned Improvements
- Enhanced error handling and reporting for R script execution
- Support for additional clustering algorithms beyond UMAP
- Automated quality control metrics generation
- Integration with popular flow cytometry analysis frameworks
- Performance optimizations for large datasets
- Better handling of edge cases in FCS file formats

### Contributing
We welcome contributions to improve the pipeline! Areas where help is particularly appreciated:
- R script optimization and error handling
- Additional visualization options
- Documentation improvements
- Testing with diverse FCS file formats

## File Structure

```
FCS-pipeline-docker-snakemake/
├── Dockerfile
├── Snakefile
├── config.yaml
├── environment.yml
├── scripts/
│   └── process_fcs.R
├── data/
│   ├── raw/          # Input FCS files
│   ├── processed/    # Output processed files
│   └── plots/        # Generated visualizations
└── .snakemake/
    └── log/          # Pipeline execution logs
```

## Output Files

For each input FCS file `sample.fcs`, the pipeline generates:
- `data/processed/sample_umap_clust.fcs`: Processed FCS file with clustering results
- `plots/sample.png`: Visualization plot

