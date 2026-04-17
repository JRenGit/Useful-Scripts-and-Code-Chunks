#!/bin/bash

#SBATCH -J reverse_array_652_513
#SBATCH -A r00302
#SBATCH -p general
#SBATCH -o filename_%j.txt
#SBATCH -e filename_%j.err
#SBATCH --cpus-per-task=4
#SBATCH --mem=64G
#SBATCH --time=48:00:00
#SBATCH --array=1-10
#SBATCH --output=logs/cram_to_bam_%A_%a.out
#SBATCH --error=logs/cram_to_bam_%A_%a.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=justren@iu.edu

#Prevent cascading errors
set -e
set -o pipefail

mkdir -p logs

module load samtools

#File paths
REF="/geode2/home/u040/justren/Quartz/fasta_ref/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna"
CRAM_BASE="/N/scratch/cmguser/production/download"
BAM_BASE="/N/project/ICMH/Projects/project_clock/data/filtered_reversed_bams"
MANIFEST="/N/slate/justren/shell_scripts/manifest652_513.csv"

#Parse the manifest for information
SAMPLE=$(awk     -F',' -v row="${SLURM_ARRAY_TASK_ID}" 'NR==row {print $1}' ${MANIFEST})
CRAM_SUB=$(awk   -F',' -v row="${SLURM_ARRAY_TASK_ID}" 'NR==row {print $2}' ${MANIFEST})
BAM_FILE=$(awk   -F',' -v row="${SLURM_ARRAY_TASK_ID}" 'NR==row {print $3}' ${MANIFEST})

CRAM="${CRAM_BASE}/${CRAM_SUB}"
OUTPUT_BAM="${BAM_BASE}/${BAM_FILE}"

echo "Sample     : ${SAMPLE}"
echo "CRAM       : ${CRAM}"
echo "Output BAM : ${OUTPUT_BAM}"
echo "Started at : $(date)"

#Create output directory if needed
mkdir -p "$(dirname ${OUTPUT_BAM})"

#Convert CRAM to BAM
samtools view \
    -h \
    -b \
    -q 20 \
    -@ ${SLURM_CPUS_PER_TASK} \
    -T "${REF}" \
    -o "${OUTPUT_BAM}" \
    "${CRAM}"

#Index the output BAM
samtools index -@ ${SLURM_CPUS_PER_TASK} "${OUTPUT_BAM}"

echo "Finished at : $(date)
