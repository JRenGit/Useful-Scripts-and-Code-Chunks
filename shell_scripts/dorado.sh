dorado="/N/slate/justren/dorado_dir/dorado-1.4.0-linux-x64/bin/dorado"

$dorado --version

$dorado basecaller \
  --device cuda:all \    ###Specify GPU usage
  --modified-bases 6mA \  ###5mC and 5hmC are combined as 5mC_5hmC
  --output-dir /N/slate/justren/dorado_outputs/ \
  /N/slate/justren/dorado_dir/dna_r10.4.1_e8.2_400bps_sup@v5.2.0 \  ###Double check which modifications are actually supported by each model
  /N/u/justren/Quartz/ICMH/Projects/MT_methyl/data/20260224_1128_1D_PBK11390_d3c61f58/pod5/PBK11390_d3c61f58_95392a4d_1.pod5 \
  --reference /N/project/ICMH/reference/mouse/GRCm39/mm39.fa  ###Change this if using human reference genome
