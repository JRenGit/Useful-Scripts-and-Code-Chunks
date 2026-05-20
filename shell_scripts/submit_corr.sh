#!/bin/bash
#SBATCH -J 6mA_corr
#SBATCH -A r00302
#SBATCH -p general
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=128G
#SBATCH --time=12:00:00
#SBATCH --output=logs/corr_%j.out
#SBATCH --error=logs/corr_%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=justren@iu.edu

# Load R module (adjust version if necessary for your cluster)
module load r/4.4.1  # Or your preferred R module

# Define paths to your samples
SAMPLE1="/N/slate/justren/shujun_validation/modkit_pileup/P1-1_6mA_pileup.bed.gz"
SAMPLE2="/N/project/ICMH/Outside/ShujunLiu/Nanopore/04_adenine/data/bedmethyl_adenine/P1-1_pre-treatment.haplotagged_dir/P1-1_pre-treatment.haplotagged_adenine.bed.gz"

# Run the R script
Rscript calc_methylation.R "$SAMPLE1" "$SAMPLE2" 1
