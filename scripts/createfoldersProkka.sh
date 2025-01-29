#!/bin/bash
local="../genomas/6-prokka"

pastas=("err" "faa" "ffn" "fna" "fsa" "gbk" "gff" "log" "sqn" "tbl" "tsv" "txt")
for pasta in "${pastas[@]}"; do
    mkdir -p "$local/$pasta"
    echo "Pasta criada: $local/$pasta"
done

for pasta in "${pastas[@]}"; do
    if ls *."${pasta}" >/dev/null 2>&1; then
        mv *."${pasta}" "$local/$pasta/"
        echo "Arquivos .${pasta} movidos para a pasta $local/$pasta/"
    else
        echo "Nenhum arquivo .${pasta} encontrado para mover."
    fi
done

echo "Organização concluída!"