BAM=/N/u/justren/Quartz/ICMH/Projects/5mC_MT/chrM_filter_compare/Su232/mapq20/Su232_chrM_mapq20.bam
MODKIT=/N/slate/justren/modkit_dir/dist_modkit_v0.5.1_8fa79e3/modkit

mkdir -p logs

$MODKIT pileup \
    $BAM \
    --max-depth 16000 \
    --filter-threshold 0.75 \
    --ref /geode2/home/u040/justren/Quartz/fasta_ref/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna \
    --threads $SLURM_CPUS_PER_TASK \
    Su232_deep_mapq20_75.bed
