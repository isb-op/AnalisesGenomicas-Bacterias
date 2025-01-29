#!/usr/bin/env python3

import pandas as pd
import re

def parse_virulence():
    info_filtered = {'genome_id':[], 'prokka_id':[], 'prokka_description':[], 'VFDB_id':[]
    , 'gene':[], 'VFDB_description':[], 'VF_name':[], 'VF_category':[], 'Species':[], 'identity':[], 'qlen':[], 'slen':[]
    }

    with open('14-viruloma/raw_viruloma.txt', 'r') as fh:

        for l in fh.readlines():
            line_split = re.split('\t', l)
            info_filtered['genome_id'].append(line_split[0])
            info_filtered['prokka_id'].append(line_split[1].split()[0])
            info_filtered['prokka_description'].append(re.search(r'\s(.*)', line_split[1]).group(1))
            info_filtered['VFDB_id'].append(re.search(r'(VF\w+)', line_split[2]).group(1))
            info_filtered['gene'].append(re.search(r'\s\((.*?)\)\s', line_split[2]).group(1))
            info_filtered['VFDB_description'].append(re.search(r'\(.*(/.*)?\)\s(.+)\s\[(.*)\]\s\[(.*)\]', line_split[2]).group(2))
            info_filtered['VF_name'].append(re.search(r'\[(.*)\s\((.*?)\)\s\-\s(.*)\]\s', line_split[2]).group(1))
            info_filtered['VF_category'].append(re.search(r'\s\-\s(.*)\s\((.*?)\)\]', line_split[2]).group(1))
            info_filtered['Species'].append(re.search(r'\[(.*)\]\s\[(.*)\]', line_split[2]).group(2))
            info_filtered['identity'].append(float(line_split[3]))
            info_filtered['qlen'].append(int(line_split[9]))
            info_filtered['slen'].append(int(line_split[10]))
    return info_filtered

df = pd.DataFrame.from_dict(parse_virulence())
df.to_csv('14-viruloma/virulome_filtered.txt', sep="\t", index=False)