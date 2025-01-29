#!/usr/bin/env bash

# Script: mash_distance_matrix.sh
# Descrição: Calcula a matriz de distância entre genomas usando MASH e converte para o formato PHYLIP.
# Uso: ./mash_distance_matrix.sh <número_de_threads>

# Verifica se o número de threads foi fornecido
if [ -z "$1" ]; then
    echo "Erro: Número de threads não fornecido."
    echo "Uso: ./mash_distance_matrix.sh <número_de_threads>"
    exit 1
fi

THREADS=$1

# Diretório de trabalho
WORK_DIR="genomas/7-mash/distance_mash/clusters"
OUTPUT_DIR="genomas/7-mash/tree"

# Cria o diretório de saída, se não existir
mkdir -p ${OUTPUT_DIR}

# Sketch dos genomas
echo "Criando sketch dos genomas com MASH..."
mash sketch -o ${OUTPUT_DIR}/reference -s 100000 ${WORK_DIR}/*.fna
# Cálculo da matriz de distância
echo "Calculando distâncias entre os genomas..."
mash dist ${OUTPUT_DIR}/reference.msh ${OUTPUT_DIR}/reference.msh -t > ${OUTPUT_DIR}/distances.tab

# Conversão para formato PHYLIP
echo "Convertendo matriz de distância para formato PHYLIP..."
tail -n +2 ${OUTPUT_DIR}/distances.tab > ${OUTPUT_DIR}/distances.tab.temp  # Remove a primeira linha
wc -l ${OUTPUT_DIR}/distances.tab.temp | awk '{print $1}' > ${OUTPUT_DIR}/distances.ndist  # Conta o número de amostras
cat ${OUTPUT_DIR}/distances.ndist ${OUTPUT_DIR}/distances.tab.temp > ${OUTPUT_DIR}/mash.phylip

# Limpeza de arquivos temporários
rm ${OUTPUT_DIR}/distances.ndist ${OUTPUT_DIR}/reference.msh ${OUTPUT_DIR}/distances.tab ${OUTPUT_DIR}/distances.tab.temp

echo "Matriz de distância MASH salva em ${OUTPUT_DIR}/mash.phylip"