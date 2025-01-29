#!/usr/bin/env python3
import pandas as pd
import re

def parse_resistence():
    info_filtered = {'genome_id':[], 'prokka_id':[], 'prokka_description':[], 'ARO':[]
    , 'gene':[], 'Species':[], 'identity':[], 'qlen':[], 'slen':[]
    }

    with open('15-resistoma/raw_esistome.txt', 'r') as fh:

        for l in fh.readlines():
            line_split = re.split('\t', l)
            info_filtered['genome_id'].append(line_split[0])
            info_filtered['prokka_id'].append(line_split[1].split()[0])
            info_filtered['prokka_description'].append(re.search(r'\s(.*)', line_split[1]).group(1))
            info_filtered['ARO'].append(re.search(r'\|.*\|(.*)\|.*\s\[.*\]', line_split[2]).group(1))
            info_filtered['gene'].append(re.search(r'\|.*\|.*\|(.*)\s\[.*\]', line_split[2]).group(1))
            info_filtered['Species'].append(re.search(r'\[(.*)\]\s', line_split[2]).group(1))
            info_filtered['identity'].append(float(line_split[3]))
            info_filtered['qlen'].append(int(line_split[9]))
            info_filtered['slen'].append(int(line_split[10]))
    return info_filtered

df = pd.DataFrame.from_dict(parse_resistence())
df.to_csv('15-resistoma/resistome_filtered.txt', sep="\t", index=False)