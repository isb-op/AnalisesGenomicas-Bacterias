```{bash, eval=FALSE}
#!/usr/bin/env bash
# Autor: francisnei_silva_pedrosa

# Nomes dos arquivos de resultados
file1=BUSCO_all.txt
file2=BUSCO_filtred.txt
file3=BUSCO_excluded.txt

# Pastas de resultados
resultsfolder=BUSCO_results
excludedfolder=excluded_genomes

printf "\n"
echo "Verificando a presença do BUSCO..."
echo "------------------------------------------------"
if command -v busco; then
    echo "BUSCO encontrado!"
else
    echo "Erro: BUSCO não encontrado."
    echo "Instale a partir de https://busco.ezlab.org/"
    exit 1
fi
printf "\n"

mkdir -p $resultsfolder/genome_files $resultsfolder/$excludedfolder

printf "\n\n"
echo -e "\e[1;36m Informe o percentual de corte para selecionar os genomas:\e[0m (ex.: 90)"
printf "\n"
read cutoff
printf "\n\n"
echo -e "\e[1;33m Iniciando análise... \e[0m"
echo "***************************************************"
printf "\n\n"

# Seleção de Genomas
echo -e "\e[1;33m Iniciando seleção de genomas:\e[0m"
echo "***************************************************"
printf "\n\n"
if test -n "$(pwd)/*/ -name 'short_summary*.txt' -print -quit"
then
for f in $(pwd)/*/short_summary*.txt; do
    echo "Copiando arquivos: "$f" "
    cp $f $(pwd)
    printf "\n"
     done
    printf "\n\n"
else
     echo -e "\e[1;31m Arquivo não encontrado. Tente novamente. \e[0m"
    fi
printf "\n"

echo -e "\e[1;33m Compilando arquivos para a lista de genomas candidatos... \e[0m"
echo "***************************************************"
printf "\n"
echo "Seleção de genomas com "$cutoff"% de qualidade:"
awk 'FNR==9 {print FILENAME, $0}' *.txt | awk '{gsub(":|\\[","\t",$2)}1''{gsub("short_summary.specific.rhodospirillales_odb10.|.txt","\t",$1)}1' | awk '{print $1,$3}' OFS="\t" > $(pwd)/../$file1
echo -e "\e[1;36m $(wc -l < $(pwd)/../$file1) genomas foram analisados.\e[0m"

awk '{if($2>='$cutoff'||$2=="100.0%") print $1,$2}' OFS="\t" $(pwd)/../$file1 > $(pwd)/../$file2
printf "\n"
echo -e "\e[1;32m $(wc -l < $(pwd)/../$file2) genomas selecionados \e[0m com qualidade >= "$cutoff"%."
echo "Salvo em: "$file2

awk '{if($2<'$cutoff'&&$2!="100.0%") print $1,$2}' OFS="\t" $(pwd)/../$file1 > $(pwd)/../$file3
printf "\n"
echo -e "\e[1;31m $(wc -l < $(pwd)/../$file3) genomas excluídos \e[0m com qualidade <= "$cutoff"%: "
echo "Salvo em: "$file3

printf "\n\n"
echo "***************************************************"
echo "Lista de genomas excluídos:"
echo ""
cat $(pwd)/../$file3
printf "\n"
echo "***************************************************"
printf "\n\n"

awk '{print $1}' OFS="\t" $(pwd)/../$file3 > temp.txt
while read line; do
    echo "Movendo $line para a pasta $excludedfolder "
    mv $(pwd)/../../$line.gz $(pwd)/../$excludedfolder/
done < temp.txt 
rm temp.txt
zip -q summary_BUSCO_results short_summary*.txt
cd ../..
rm *.fna
printf "\n\n"

echo "Concluído!"
printf "\n"