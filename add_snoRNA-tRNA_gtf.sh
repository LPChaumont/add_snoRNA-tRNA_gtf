#!/usr/bin/env bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 /path/to/ensembl.gtf /path/to/GtRNAdb_directory/"
    exit 1
fi

bash ./snoRupdate_ensembl_gtf.sh $1
bash ./add_tRNA_ensembl_gtf.sh "${1%.*}.snoDB.${1##*.}" $2