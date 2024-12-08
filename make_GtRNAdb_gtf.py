#!/usr/bin/env python 

import os
import sys

if len(sys.argv) != 2:
    print("Usage: python sys.argv[0] /path/to/GtRNAdb_directory/")
    sys.exit(1)

GtRNAdb_dir = sys.argv[1]
bed_filename = [f for f in os.listdir(GtRNAdb_dir) if f.endswith('-tRNAs.bed')][0]
bed_path = os.path.join(GtRNAdb_dir, bed_filename)
source = 'GtRNAdb'
score = '.'
frame = '.'
biotype = 'tRNA'
gtf_list = []

with open(bed_path, 'r') as f:
    for line in f:
        col = line.strip().split('\t')
        name = col[3]
        
        # common fields for all features
        must_fields = [
            col[0].split('chr')[1],   # chr
            source,                   # source
            '',                       # feature
            col[1],                   # start
            col[2],                   # end
            score,                    # score
            col[5],                   # strand
            frame                     # frame
        ]
        
        # base attributes for all features
        base_attributes = [
            f'gene_id "{name}"',
            f'gene_name "{name}"',
            f'gene_biotype "{biotype}"',
            f'gene_source "{source}"',
            'gene_version "1"'
        ]

        # common transcript/exon attributes
        common_transcript_attributes = [
            f'transcript_id "{name}"',
            f'transcript_name "{name}"',
            f'transcript_biotype "{biotype}"',
            f'transcript_source "{source}"',
            'transcript_version "1"',
            'transcript_support_level "NA"',
            'tag "basic"'
        ]

        for feature in ['gene', 'transcript', 'exon']:
            # gene/transcript/exon
            must_fields[2] = feature
            attributes = '; '.join(base_attributes) + '; '
            
            # transcript/exon
            if feature == 'transcript' or feature == 'exon':
                attributes += '; '.join(common_transcript_attributes) + '; '
            # exon
            if feature == 'exon':
                attributes += 'exon_number "1"; exon_version "1"; '
            
            all_fields = '\t'.join(must_fields + [attributes]) + '\n'
            gtf_list.append(all_fields)

directory, filename = os.path.split(bed_path)
name, _ = os.path.splitext(filename)
gtf_fout = os.path.join(directory, name + '.gtf')

with open(gtf_fout, 'w') as out_file:
    out_file.writelines(gtf_list)
