#!/bin/bash
#SBATCH -J modkit_6mA_array
#SBATCH -A r00302
#SBATCH -p general
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --time=48:00:00
#SBATCH --array=1-10
#SBATCH --output=logs/modkit_pileup_%A_%a.out
#SBATCH --error=logs/modkit_pileup_%A_%a.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=justren@iu.edu

module load samtools
module load htslib

set -e
set -o pipefail

mkdir -p logs

REF=/geode2/home/u040/justren/Quartz/fasta_ref/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna
BAM_BASE=/N/project/ICMH/Projects/project_clock/data/filtered_reversed_bams
OUTPUT_BASE=/N/project/ICMH/Projects/project_clock/data/MODKIT_PILEUP_6mA
MODKIT=/N/slate/justren/modkit_dir/dist_modkit_v0.5.1_8fa79e3/modkit
MANIFEST=/N/slate/justren/shell_scripts/manifest760_597.csv

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
    - \
    --motif A 0 \
    --ref "${REF}" \
    --threads ${SLURM_CPUS_PER_TASK} \
    --log-filepath "logs/modkit_${SAMPLE}_${SLURM_ARRAY_JOB_ID}_${SLURM_ARRAY_TASK_ID}.txt" \
    | bgzip -c > ${OUTPUT_BED}.gz

echo "Finished at : $(date)"
echo "Output size : $(du -h ${OUTPUT_BED}.gz)"
