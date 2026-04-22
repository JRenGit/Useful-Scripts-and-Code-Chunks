#!/bin/bash
#SBATCH -J snakemake_controller
#SBATCH -A r00302
#SBATCH -p general
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --time=72:00:00
#SBATCH --output=logs/snakemake_controller_%j.out
#SBATCH --error=logs/snakemake_controller_%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=justren@iu.edu

set -e
set -o pipefail
mkdir -p logs

source activate snakemake

snakemake \
  --slurm \
  --jobs 10 \
  --use-envmodules \
  --default-resources \
      slurm_account=r00302 \
      slurm_partition=general \
  --latency-wait 60 \
  --rerun-incomplete \
  --printshellcmds
