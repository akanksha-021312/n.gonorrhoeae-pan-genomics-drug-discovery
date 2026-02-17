#!/bin/bash


# PC requirement:
# Linux environment
# Anaconda software
# Input data

# Adding channels to conda 
conda config --add channels r
conda config --add channels bioconda
conda config --add channels conda-forge

################################################
# STEP 1: Genome Annotation using PROKKA
################################################

# create an Environment and installing prokka
conda create -n prokka -c bioconda -c conda-forge prokka

# activatation of environment
conda activate prokka

mkdir prokka_outputs

for genome in genomes/*.fasta
do
    base=$(basename "$genome" .fasta)

    echo "Annotating $base ..."

    prokka --cpus 4 \
           --prefix "$base" \
           --kingdom Bacteria \
           --locustag "$base" \
           --outdir prokka_outputs/"$base" \
           "$genome"

done

echo "Prokka annotation completed."

#  genome_1.faa file consists of fasta sequences

################################################
# STEP 3: Collect GFF files for Roary
################################################

mkdir gff_files

find prokka_outputs/ -name "*.gff" -exec cp {} gff_files/ \;

echo "All GFF files collected."

################################################
# STEP : Pan-genome Analysis using ROARY
################################################

# create an Environment and installing 
conda create -n pangenome roary

# activatation of environment
conda activate pangenome

#save the roary.py(find in scripts/) in the current directory to get plots and image as a part of roary output
# to run this python code, need to install some python packages
pip install numpy
pip install matplotlib
pip install seaborn
pip install pandas
pip install biopython

# place all the fasta sequences obtained from the .faa files of each genome in to a folder named "sequences"
mkdir sequences 
ls sequences


# performing Roary
roary -f roaryresults -p 4 -e -n -v gff_files/*.gff

# roaryresults folder will consists of following files as roary output
# accessory_binary_genes.fa
# accessory_binary_genes.fa.newick
# accessory_graph.dot
# accessory_header.embl
# accessory.tab
# blast_identity_frequency.Rtab
# clustered_proteins
# core_accessory_graph.dot
# core_accessory_header.embl
# core_accessory.tab
# core_alignment_header.embl
# core_gene_alignment.aln
# gene_presence_absence.csv
# gene_presence_absence.Rtab
# number_of_conserved_genes.Rtab
# number_of_genes_in_pan_genome.Rtab
# number_of_new_genes.Rtab
# number_of_unique_genes.Rtab
# pan_genome_reference.fa
# summary_statistics.txt

################################################
# STEP 3: Phylogenetic Tree Construction
################################################

FastTree -nt -gtr roaryresult/core_gene_alignment.aln > roaryresults/tree.newick

################################################
# STEP 4: Visualization using roary.py
################################################


python roary.py --labels roaryresults/tree.newick roaryresults/gene_presence_absence.csv

#the images will be saved as .png in the current working directory