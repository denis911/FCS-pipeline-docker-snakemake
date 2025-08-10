  This is an FCS (Flow Cytometry Standard) file analysis pipeline built with Snakemake. Here's the structure:

  Core Components:

  - Pipeline: Snakemake workflow (Snakefile) that processes FCS files through a standardized analysis        
  - Processing Script: R script (scripts/process_fcs.R) that handles the actual data transformation
  - Environment: Conda environment (environment.yml) with R packages for flow cytometry analysis
  - Configuration: YAML config for directory paths and clustering parameters

  Data Flow:

  1. Input: Raw FCS files in data/raw/
  2. Processing:
    - Channel selection (non-empty descriptions, excluding scatter channels)
    - asinh transformation (cofactor 5)
    - 2D UMAP embedding
    - K-means clustering (5 clusters)
  3. Output:
    - Processed FCS files with UMAP coordinates and cluster labels in data/processed/
    - UMAP plots colored by cluster in plots/

  Key Files:

  - Snakefile:1-26 - Main workflow definition
  - scripts/process_fcs.R:1-39 - Core R processing logic
  - channels.txt:1-65 - Channel metadata with usage flags (last column: 1=use, 0=ignore)
  - config.yaml:1-4 - Pipeline configuration
  - environment.yml:1-17 - Dependency management

  