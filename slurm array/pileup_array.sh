#!/bin/bash
#SBATCH -J modkit_6mA_array
#SBATCH -A r00302
#SBATCH -p general
#SBATCH --cpus-per-task=4
#SBATCH --mem=64G
#SBATCH --time=48:00:00
#SBATCH --array=2-2
#SBATCH --output=logs/modkit_pileup_%A_%a.out
#SBATCH --error=logs/modkit_pileup_%A_%a.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=justren@iu.edu

set -e
set -o pipefail

mkdir -p logs

REF=/geode2/home/u040/justren/Quartz/fasta_ref/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna
BAM_BASE=/N/project/ICMH/Projects/project_clock/data/filtered_reversed_bams
OUTPUT_BASE=/N/project/ICMH/Projects/project_clock/data/modkit_6mA_pileup
MODKIT=/geode2/home/u040/justren/Quartz/modkit  # adjust to your modkit binary path
MANIFEST=manifest.csv

# Parse manifest row for this task
SAMPLE=$(awk  -F',' -v row="${SLURM_ARRAY_TASK_ID}" 'NR==row {print $1}' ${MANIFEST})
BAM_FILE=$(awk -F',' -v row="${SLURM_ARRAY_TASK_ID}" 'NR==row {print $3}' ${MANIFEST})

INPUT_BAM="${BAM_BASE}/${BAM_FILE}"
OUTPUT_BED="${OUTPUT_BASE}/${SAMPLE}_6mA_pileup.bed"

echo "Sample     : ${SAMPLE}"
echo "Input BAM  : ${INPUT_BAM}"
echo "Output BED : ${OUTPUT_BED}"
echo "Started at : $(date)"

# Validate input
if [[ ! -f "${INPUT_BAM}" ]]; then
    echo "ERROR: BAM not found: ${INPUT_BAM}" >&2
    exit 1
fi

if [[ ! -f "${INPUT_BAM}.bai" && ! -f "${INPUT_BAM%.bam}.bai" ]]; then
    echo "ERROR: BAM index not found for ${INPUT_BAM}" >&2
    exit 1
fi

# Create output directory if needed
mkdir -p "$(dirname ${OUTPUT_BED})"

# Run modkit pileup (6mA only)
${MODKIT} pileup \
    "${INPUT_BAM}" \
    "${OUTPUT_BED}" \
    --ref "${REF}" \
    --motif A 0 \
    --threads ${SLURM_CPUS_PER_TASK} \
    --log-filepath "logs/modkit_${SAMPLE}_${SLURM_ARRAY_JOB_ID}_${SLURM_ARRAY_TASK_ID}.log"

echo "Finished at : $(date)"
echo "Output size : $(du -h ${OUTPUT_BED})"
