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

Corrected R script with all the major bugs fixed:
Fixes Applied:

K-means Input: Changed k-means clustering to use expr_trans (transformed expression data) instead of umap_res (UMAP coordinates), as required.

Code Quality Improvements:
Consistent Styling: Applied R style guide with proper spacing, indentation, and naming
Comprehensive Comments: Added detailed comments explaining each major step
Error Handling: Added validation for file existence and required columns
Informative Logging: Added cat() statements to track processing progress
Improved Plot: Enhanced the visualization with better theming and labels
Code Organization: Logical grouping of related operations with clear section breaks



  