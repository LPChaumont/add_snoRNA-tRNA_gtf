#!/usr/bin/env bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 /path/to/ensembl.gtf"
    exit 1
fi

IN_GTF=$(realpath "$1")
TMP_GTF="$IN_GTF.tmp"
OUT_SNORUPDATE="${IN_GTF%.*}_snoRNAs.${IN_GTF##*.}"
OUT_GTF="${IN_GTF%.*}.snoDB.${IN_GTF##*.}"

SNODB_URL="https://bioinfo-scottgroup.med.usherbrooke.ca/media/snoDB/versions/2.0/snoDB_All_V2.0.tsv"
SNODB="snoDB_All_V2.0.tsv"
SNORNA_ID="ensembl_snorna_id.txt"

# prepare snoRupdate
if [ ! -d "snoRupdate" ]; then
    git clone https://github.com/scottgroup/snoRupdate.git
else
    echo "snoRupdate already exists: skipping cloning"
fi
cd snoRupdate
./compile.sh
sed -i "s|^gtfPath = .*|gtfPath = $TMP_GTF|" config.ini

# get all ensembl snoRNA IDs from snoDB
# split semicolon separated ensembl IDs
wget -nc "$SNODB_URL" --no-check-certificate
awk -F'\t' 'NR > 1 { 
    n = split($2, id, ";");
    for (j = 1; j <= n; j++) { 
        print id[j];
    } 
}' "$SNODB" > "$SNORNA_ID"

# remove all trace of snoRNAs from the GTF
grep -vFf "$SNORNA_ID" "$IN_GTF" > "$TMP_GTF"

# run snoRupdate
./run.sh
mv "$OUT_SNORUPDATE" "$OUT_GTF"
rm "$TMP_GTF"
