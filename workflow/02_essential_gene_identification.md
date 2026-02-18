## Core Gene Extraction and Essential Gene Identification

###############################

Step 1: Core Gene Extraction

###############################

Core genes were identified from the Roary output file:

roaryresults/gene_presence_absence.csv

A Python script ("scripts/extraction_core_genes.py) was used to classify genes as:

- Core genes (present in ≥ 95% of genomes)
- Accessory genes (present in < 95% of genomes)

Core Gene Definition

A gene was considered core if:

Presence ≥ 95% of total genomes (194 isolates)

###############################################

Step 2: Core Gene FASTA Sequences Extraction

###############################################

After identifying core genes, their nucleotide sequences are extracted from the pan-genome reference FASTA file.

Input:

1) core_genes.csv

2) pan_genome_reference.fa

A Python script ("scripts/extraction_core_fasta_seq.py) was used and output is stored in core_genes_sequences.fa file.

##################################

Step 3: Essential Gene Identification

##################################

Core gene sequences were extracted and subjected to BLAST against the Database of Essential Genes (DEG).

Tool Used:

DEG BLASTp web server

Parameters:

E-value < 1e-4

Genes showing significant matches were considered essential genes required for bacterial survival.

Extract the 'RefSeq ID' for each essential gene from the Database of Essential Genes (DEG) and save it to essential_genome_ids.txt.
 
###########################################################################

## Step 4: Converting Nucleotide FASTA sequences to Protein FASTA sequences

###########################################################################

After identifing essential genes, extract the 'RefSeq ID' for each essential gene from the Database of Essential Genes (DEG) and save it to 'essential_genome_ids.txt.'

After identifying essential genomes, protein sequences were retrieved from NCBI GenBank records using Biopython’s Entrez module. All CDS features containing translated protein sequences were extracted and saved in FASTA format.

Input:

essential_genome_ids.txt

A Python script ("scripts/fetch_proteins_from_genomes.py") was used and output is stored in proteins_from_genome.fasta file.

All the python scripts used in this part of workflow are stored in 'scripts' folder















