from Bio import SeqIO

# Input files with your specified paths
core_genes_csv = "path_to_file/core_genes.csv"
fasta_file = "path_to_file/pan_genome_reference.fa"
output_fasta = "path_to file/core_genes_sequences.fa"

# Load the core genes from the CSV file
import pandas as pd
core_genes_df = pd.read_csv(core_genes_csv)
core_genes = set(core_genes_df['Gene'].dropna().unique())  # Get unique core gene names

# Extract the sequences of the core genes
with open(output_fasta, "w") as output_handle:
    for record in SeqIO.parse(fasta_file, "fasta"):
        # Extract the gene name after the first space in the FASTA header
        gene_name = record.description.split()[1]  # This gets the gene name (e.g., 'dnaA')
        if gene_name in core_genes:
            SeqIO.write(record, output_handle, "fasta")
            print(f"Found core gene: {gene_name}")  # Optional: Debugging print statement

print(f"Core gene sequences saved to {output_fasta}")
