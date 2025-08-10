#!/usr/bin/env Rscript

# Flow Cytometry Data Processing Script
# Performs channel selection, transformation, UMAP dimensionality reduction, 
# and k-means clustering on FCS files

# Load required libraries
library(optparse)
library(flowCore)
library(ggplot2)
library(uwot)

# Define command line options
option_list <- list(
  make_option(c("-i", "--input"), 
              type = "character", 
              help = "Input FCS file path"),
  make_option(c("-o", "--output"), 
              type = "character", 
              help = "Output FCS file path"),
  make_option(c("-p", "--plot"), 
              type = "character", 
              help = "Output plot file path"),
  make_option(c("-c", "--channels"), 
              type = "character", 
              help = "Channels configuration file (channels.txt)")
)

# Parse command line arguments
opt <- parse_args(OptionParser(option_list = option_list))

# Validate required arguments
if (is.null(opt$input) || is.null(opt$output) || is.null(opt$plot)) {
  stop("Error: Input, output, and plot file paths must be provided")
}

# Read the FCS file
cat("Reading FCS file:", opt$input, "\n")
ff <- read.FCS(opt$input, transformation = FALSE)

# Channel selection logic
if (!is.null(opt$channels)) {
  # Use channels.txt configuration file for channel selection
  cat("Using channel configuration file:", opt$channels, "\n")
  
  if (!file.exists(opt$channels)) {
    stop("Error: Channels configuration file not found: ", opt$channels)
  }
  
  # Read channel configuration
  channel_config <- read.delim(opt$channels, stringsAsFactors = FALSE)
  
  # Validate channel configuration format
  required_cols <- c("name", "use")
  if (!all(required_cols %in% colnames(channel_config))) {
    stop("Error: channels.txt must contain 'name' and 'use' columns")
  }
  
  # Filter channels where use=1
  use_channels <- channel_config$name[channel_config$use == 1]
  
  # Get indices of channels to use
  channels <- which(colnames(ff) %in% use_channels)
  
  if (length(channels) == 0) {
    stop("Error: No matching channels found in FCS file")
  }
  
  cat("Selected", length(channels), "channels from configuration file\n")
  
} else {
  # Fallback to automatic channel selection (exclude FSC/SSC channels)
  cat("No channel configuration provided, using automatic selection\n")
  
  params <- parameters(ff)
  desc <- pData(params)$desc
  
  # Select channels that have descriptions and are not FSC/SSC
  channels <- which(!is.na(desc) & !grepl("^FSC|^SSC", desc, ignore.case = TRUE))
  
  cat("Automatically selected", length(channels), "channels\n")
}

# Extract expression data for selected channels
cat("Extracting expression data for selected channels\n")
expr <- exprs(ff)[, channels, drop = FALSE]

# Apply asinh transformation (cofactor = 5)
cat("Applying asinh transformation\n")
expr_trans <- asinh(expr / 5)

# Perform UMAP dimensionality reduction
cat("Computing UMAP embedding\n")
umap_res <- umap(expr_trans, n_components = 2)

# Perform k-means clustering on transformed expression data
cat("Performing k-means clustering (k=5)\n")
km <- kmeans(expr_trans, centers = 5)

# Create new expression matrix with original data + UMAP coordinates + cluster assignments
cat("Creating output FCS file with UMAP and cluster data\n")
new_expr <- cbind(
  exprs(ff),                    # Original expression data
  UMAP1 = umap_res[, 1],       # First UMAP component
  UMAP2 = umap_res[, 2],       # Second UMAP component
  Cluster = km$cluster         # Cluster assignments
)

# Create new flowFrame object
new_ff <- flowFrame(new_expr)

# Write output FCS file
cat("Writing output FCS file:", opt$output, "\n")
write.FCS(new_ff, filename = opt$output)

# Create visualization
cat("Creating UMAP plot\n")
df <- data.frame(
  UMAP1 = umap_res[, 1],
  UMAP2 = umap_res[, 2],
  Cluster = factor(km$cluster)
)

# Generate plot
plt <- ggplot(df, aes(x = UMAP1, y = UMAP2, color = Cluster)) +
  geom_point(size = 0.5, alpha = 0.7) +
  labs(
    title = "UMAP Visualization with K-means Clusters",
    x = "UMAP1",
    y = "UMAP2"
  ) +
  theme_minimal() +
  theme(
    legend.position = "right",
    plot.title = element_text(hjust = 0.5)
  )

# Save plot
cat("Saving plot to:", opt$plot, "\n")
ggsave(opt$plot, plot = plt, width = 8, height = 6, dpi = 300)

cat("Processing completed successfully\n")

