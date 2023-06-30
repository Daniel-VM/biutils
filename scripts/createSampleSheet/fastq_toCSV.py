#!/usr/bin/env python3
# Load modules
from numpy import NaN
import pandas as pd
import collections
import argparse
import re
import sys
import os
# ===============================================
#               PARSING ARGUMENTS
# ===============================================



# Isolate fastq files
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Parsing fastq files into samplesheet format. Stantarized for nextflow")
    parser.add_argument('-pe', '--paired_end', action='store_true', help = 'Boolean indicating wether sequences are paried-end')
    parser.add_argument('-i', '--input', default = [], nargs='+')
    parser.add_argument('-o', '--outdir', default = [], nargs='+', type = str)
    parser.parse_args()
    args = vars(parser.parse_args())

# Scanning forward and reverse reads
if args['paired_end']:
    read_fwd = args['input'][0::2]
    read_rev = args['input'][1::2]
else:
    read_fwd = args['input']


# process database
data = collections.defaultdict(list)

# Get reads file name items
for x in read_fwd:
    filename = os.path.basename(x)
    base_name = re.sub(r'.(fastq|fq).gz', "",filename)
# doesnt work with custom labels, but it does with illumina/crg raw labels
#    if base_name.find("_R1_")!=-1 or base_name.find("_R2_")!=-1:
#        sample_name =  re.sub(r'_R1|_R2', "",base_name)
#    else:
#        sample_name =  re.sub(r'_1|_2', "",base_name)
    
    data['sample'].append(base_name) # sustitute base_name with sample_name
    data['fastq_1'].append(x)

if args['paired_end']:
    for z in read_rev:
        data['fastq_2'].append(z)
        data['paired_end'].append('false')
else:
    for z in read_fwd:
        data['fastq_2'].append("")
        data['paired_end'].append('false')


# Transform summary dict to dataframe and save it
df = pd.DataFrame(data)
if args['outdir']:
    outfile = '{}/{}'.format(args['outdir'][0], 'reads_sampleSheet.csv')
    df.to_csv(outfile, index=False)
else:    
    df.to_csv('reads_sampleSheet.csv', index=False)
print(df)
