import os

configfile: "config.yaml"

rule all:
    input:
        os.path.join(config["base_output_dir"], os.path.basename(config["input_dir"].rstrip("/")))

rule dorado_pipeline:
    input:
        pod5_dir   = config["input_dir"],
        sample_sheet = config["sample_sheet"]
    output:
        run_dir = directory(os.path.join(config["base_output_dir"], os.path.basename(config["input_dir"].rstrip("/"))))
    params:
        dorado = config["dorado"],
        model  = config["model"],
        kit    = config["kit"],
        mods   = " ".join(config["mods"]) if isinstance(config["mods"], list) else config["mods"]
    shell:
        """
        RUN_DIR="{output.run_dir}"
        mkdir -p "$RUN_DIR"

        RUN_ID=$(basename "{input.pod5_dir}")
        TMP_BAM="$RUN_DIR/${{RUN_ID}}_calls.bam"

        # Step 1: Basecall, assign barcodes, and map aliases via the sample sheet
        # Dorado requires --no-trim so barcodes are not destroyed before the demuxer reads them
        "{params.dorado}" basecaller "{params.model}" "{input.pod5_dir}" \
            --kit-name "{params.kit}" \
            --modified-bases {params.mods} \
            --sample-sheet "{input.sample_sheet}" \
            --no-trim \
            > "$TMP_BAM"

        # Step 2: Demux reads into per-barcode files
        "{params.dorado}" demux \
            --output-dir "$RUN_DIR" \
            "$TMP_BAM"

        echo "Processing complete for ${{RUN_ID}}. Files split by barcode are in $RUN_DIR"
        """
