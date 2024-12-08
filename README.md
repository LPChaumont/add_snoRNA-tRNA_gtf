# Ensembl GTF Annotation Enhancer for snoRNA and tRNA 

This repository provides scripts to add **snoRNA** and **tRNA** annotations to an Ensembl GTF file by incorporating data from external databases.

## Annotation database  

- [**snoDB 2.0**](https://bioinfo-scottgroup.med.usherbrooke.ca/snoDB/): An enhanced interactive database, specializing in human snoRNAs.
    > Danny Bergeron, Hermes Paraqindes, Étienne Fafard-Couture, Gabrielle Deschamps-Francoeur, Laurence Faucher-Giguère, Philia Bouchard-Bourelle, Sherif Abou Elela, Frédéric Catez, Virginie Marcel, Michelle S Scott, [snoDB 2.0: an enhanced interactive database, specializing in human snoRNAs](https://doi.org/10.1093/nar/gkac835), Nucleic Acids Research, Volume 51, Issue D1, 6 January 2023, Pages D291–D296

- [**GtRNAdb 2.0**](https://gtrnadb.ucsc.edu/index.html): An expanded database of transfer RNA genes identified in complete and draft genomes.
    > Chan, P.P. & Lowe, T.M. (2016) [GtRNAdb 2.0: an expanded database of transfer RNA genes identified in complete and draft genomes](https://doi.org/10.1093/nar/gkv1309). Nucl. Acids Res. 44(Database issue):D184-D189.

## Usage
The output GTF file will have either or both of the suffixes `.snoDB` and `.GtRNAdb` based on the annotations added.

For **hg38** tRNA annotations, please manually download the database from the [GtRNAdb website](https://gtrnadb.ucsc.edu/genomes/eukaryota/Hsapi38/) under the "Download tRNAscan-se Results" tab. After downloading, extract the data with the following commands:
```bash
mkdir -p GtRNAdb_hg38
tar -xvzf hg38-tRNAs.tar.gz -C GtRNAdb_hg38
rm hg38-tRNAs.tar.gz
```

### add_snoRNA_gtf.sh
- Adds snoRNA annotations from **snoDB** to the input GTF using [snoRupdate](https://github.com/scottgroup/snoRupdate). 
```bash
bash add_snoRNA_gtf.sh /path/to/ensembl.gtf
```

### add_tRNA_gtf.sh  
- Adds tRNA annotations from **GtRNAdb** to the input GTF.
```bash
bash add_tRNA_gtf.sh /path/to/ensembl.gtf /path/to/GtRNAdb_directory/  
```  

### add_snoRNA-tRNA.sh  
- Combines both snoRNA and tRNA annotations into the input GTF in a single step.
```bash
bash add_snoRNA-tRNA.sh /path/to/ensembl.gtf /path/to/GtRNAdb_directory/  
```
---
### make_GtRNAdb_gtf.py  
- Script used by the two previous scripts to processes **GtRNAdb** bed file into GTF format. 
``` bash
bash make_GtRNAdb_gtf.py /path/to/GtRNAdb_directory/
```

## Bonus
You can parse the attributes column of a GTF into different columns with [gtfParser](https://github.com/dannyxbergeron/gtfParser)