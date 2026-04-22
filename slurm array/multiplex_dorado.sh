# Define paths
dorado="/N/slate/justren/dorado_dir/dorado-1.4.0-linux-x64/bin/dorado"
INPUT_DIR="/N/project/ICMH/Projects/MT_methyl/data/pod5_16_30"
MODEL="/N/slate/justren/dorado_dir/dna_r10.4.1_e8.2_400bps_sup@v5.2.0"
SAMPLE_SHEET="/N/slate/justren/dorado_outputs/sample_sheet.csv"
BASE_OUTPUT_DIR="/N/u/justren/Quartz/ICMH/Projects/MT_methyl/data/basecalled_data"

RUN_ID=$(basename "$INPUT_DIR")
RUN_DIR="$BASE_OUTPUT_DIR/$RUN_ID"

mkdir -p "$RUN_DIR"

TMP_BAM ="$RUN_DIR/${RUN_ID}_calls.bam"
 
$dorado basecaller $MODEL $INPUT_DIR \
        --kit-name SQK-NBD114-24 \
        --modified-bases 6mA 5mCG_5hmCG \
         > $TMP_BAM
$dorado demux \
        --no-classify \
        --sample-sheet "$SAMPLE_SHEET" \
        --output-dir "$RUN_DIR" \
        "$TMP_BAM"

echo "Processing complete for $RUN_ID. Files are located in $RUN_DIR"
