# Define paths
dorado="/N/slate/justren/dorado_dir/dorado-1.4.0-linux-x64/bin/dorado"
INPUT_DIR="/N/project/ICMH/Projects/MT_methyl/data/pod5_1_15"
MODEL="/N/slate/justren/dorado_dir/dna_r10.4.1_e8.2_400bps_sup@v5.2.0"
SAMPLE_SHEET="/N/slate/justren/dorado_outputs/samples_sheet.csv"
OUTPUT_DIR="/N/u/justren/Quartz/ICMH/Projects/MT_methyl/data/basecalled_data"
TMP_BAM="$OUTPUT_DIR/combined_calls.bam"

$dorado basecaller $MODEL $INPUT_DIR --kit-name SQK-NBD114-24 > $TMP_BAM
$dorado demux --no-classify --sample-sheet $SAMPLE_SHEET --output-dir $OUTPUT_DIR $TMP_BAM
