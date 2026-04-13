#!/bin/bash

#SBATCH -J job_name
#SBATCH -p general
#SBATCH -o filename_%j.txt
#SBATCH -e filename_%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=justren@iu.edu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=12:00:00
#SBATCH --mem=16G
#SBATCH -A r00302
#SBATCH --output=logs/%x_%A_%a.out
#SBATCH --error=logs/%x_%A_%a.err

module load samtools

srun samtools view -h -b -q 20 \
-T /geode2/home/u040/justren/Quartz/fasta_ref/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna \
-o /N/slate/justren/remade_bams/Su780_revert.bam \
/N/scratch/cmguser/production/download/e848b79b-2ff6-4db9-9573-4ea3e5f40e6c/Su780_BTRC_267_AUD_M.haplotagged.cram
