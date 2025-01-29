#!/bin/bash

local="../genomas"

pastas=(
    "1-assembly_fna"
    "2-bbmap_fasta"
    "3-quast"
    "4-checkm"
    "5-busco"
    "6-prokka"
    "7-mash"
    "8-fastani_mash"
    "9-pocp"
    "10-pyani"
    "11-roary"
    "12-orthofinder"
    "13-iqtree"
    "14-viruloma"
    "15-resistoma"
)

for pasta in "${pastas[@]}"; do
    mkdir -p "$local/$pasta"
    echo "Pasta criada: $local/$pasta"
done

echo "Todas as pastas foram criadas com sucesso em $local!"