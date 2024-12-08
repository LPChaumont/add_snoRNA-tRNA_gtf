#!/usr/bin/env bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 /path/to/ensembl.gtf /path/to/GtRNAdb_directory/"
    exit 1
fi

IN_GTF=$1
GtRNAdb_DIR=$2
OUT_GTF="${IN_GTF%.*}.GtRNAdb.${IN_GTF##*.}"

# wget and curl don't work, download it manually at under the tab 'Download tRANscan-Se Results'
#URL="https://gtrnadb.ucsc.edu/genomes/eukaryota/Hsapi38/hg38-tRNAs.tar.gz"
#mkdir -p "$GtRNAdb_DIR"
#tar -xvzf hg38-tRNAs.tar.gz -C "$GtRNAdb_DIR"
#rm hg38-tRNAs.tar.gz

python ./make_GtRNAdb_gtf.py "$GtRNAdb_DIR"

tRNA_GTF=$(find "$GtRNAdb_DIR" -type f -name '*-tRNAs.gtf')

cat "$IN_GTF" "$tRNA_GTF" > "$OUT_GTF"
