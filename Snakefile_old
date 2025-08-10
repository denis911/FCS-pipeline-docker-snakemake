import os, glob

configfile: "config.yaml"

RAW_DIR = config["raw_dir"]
PROCESSED_DIR = config["processed_dir"]
PLOT_DIR = config["plot_dir"]
N_CLUSTERS = config.get("n_clusters", 5)

# Detect all FCS sample names (remove .fcs extension)
samples = [os.path.splitext(os.path.basename(f))[0]
           for f in glob.glob(os.path.join(RAW_DIR, '*.fcs'))]

# debugging only - KD - printing out samples
print(f"Found samples: {samples}")

rule all:
    input:
        expand(os.path.join(PROCESSED_DIR, '{sample}_umap_clust.fcs'), sample=samples),
        expand(os.path.join(PLOT_DIR, '{sample}.png'), sample=samples)

# debugging only - KD - printing out samples
print(f"RAW_DIR: {RAW_DIR}")
print(f"Files in RAW_DIR: {glob.glob(os.path.join(RAW_DIR, '*'))}")
print(f"FCS files found: {glob.glob(os.path.join(RAW_DIR, '*.fcs'))}")

rule process_fcs:
    input:
        fcs=os.path.join(RAW_DIR, '{sample}.fcs')
    output:
        fcs=os.path.join(PROCESSED_DIR, '{sample}_umap_clust.fcs'),
        plot=os.path.join(PLOT_DIR, '{sample}.png')
    shell:
        """
        Rscript "{workflow.basedir}/scripts/process_fcs.R" \
            -i "{input.fcs}" -o "{output.fcs}" -p "{output.plot}"
        """
