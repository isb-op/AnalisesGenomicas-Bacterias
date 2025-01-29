# Analises Genômicas para bactérias

Pipeline Genomics Azospirillum

Este repositório contém um pipeline de bioinformática para análise de genomas de procariotos, focado no gênero *Azospirillum*. O objetivo é processar grandes conjuntos de dados genômicos, filtrar informações não confiáveis e realizar análises filogenéticas e pangenômicas.

## Objetivos
- Obter um grande conjunto de dados genômicos e filtrar dados irrelevantes.
- Delimitar bactérias pertencentes a um mesmo gênero e avaliar a distância entre membros de uma mesma família.
- Identificar espécies e avaliar o pangenoma do gênero.
- Reconstruir a filogenia dos organismos analisados.

## Requisitos
Para executar o pipeline, é necessário ter instalado:
- Miniconda ou Anaconda para gerenciamento de pacotes.
- R e RStudio.
- Pacotes R: `tidyverse`, `Biostrings`, `ggplot2`, entre outros.
- Ferramentas bioinformáticas instaladas dentro do ambiente conda:
  ```sh
  conda install -c bioconda entrez-direct
  conda install -c bioconda bbmap
  conda install -c bioconda quast
  conda install -c bioconda checkm
  conda install -c bioconda busco=5.3.2
  conda install -c bioconda -c defaults prokka
  conda install -c bioconda mash
  conda install -c bioconda fastani
  conda install -c bioconda blast
  conda install -c bioconda quicktree
  conda install -c bioconda pyani
  conda install -c bioconda orthofinder
  ```  
## Como Usar
1. Clone o repositório:
   ```sh
   git clone https://github.com/seu-usuario/seu-repositorio.git
   ```
2. Abra o arquivo `Pipeline_Bioinformatica.Rmd` no RStudio.
3. Instale as dependências listadas se ainda não estiverem instaladas.
4. Execute o pipeline por seção e seguindo as instruções.
5. Ajuste os diretórios nos scripts conforme a estrutura de pastas do seu computador. Certifique-se de modificar os caminhos indicados nos códigos para que apontem corretamente para os arquivos em sua máquina.

## Estrutura do Repositório
```
/
Pipeline_Bioinformatica.Rmd  # Documento principal do pipeline
genomas/
    ├──1-assembly_fna/    # Genomas brutos em formato .fna
    ├──2-bbmap_fasta/     # Genomas filtrados pelo BBmap
    ├──3-quast/           # Resultados do QUAST
    ├──4-checkm/          # Resultados do CheckM
    ├──5-busco/           # Resultados do BUSCO
    ├──6-prokka/          # Anotação de genomas com Prokka
    │	    ├──err/
    │	    ├──faa/
    │	    ├──ffn/
    │	    ├──fna/
    │	    ├──fsa/
    │	    ├──gbk/
    │	    ├──gff/
    │	    ├──log/
    │	    ├──sqn/
    │	    ├──tbl/
    │	    ├──tsv/
    │	    └──txt/
    │
    ├──7-mash/            # Análise de distância genômica 
    │  └── distance_mash/
    │      └── clusters/   
    ├──8-fastani_mash/   #FastAni e Mash  
    │  └── tree/
    ├──9-pocp/           # Análise de POCP
    ├──10-pyani/         # Análise de ANI com PyANI
    ├──11.roary/         # Análise do Pangenoma com Roary
    ├──12-orthofinder/   # Ortologia filogenética 
    ├──13-iqtree/        # Reconstrução filogenética 
    ├──14-viruloma/      # Análise de genes de virulência
    └──15-resistoma/     # Análise de genes de resistência 
scripts/      
```

## Contribuição
Contribuições são bem-vindas! Sinta-se à vontade para abrir uma issue ou enviar um pull request.
