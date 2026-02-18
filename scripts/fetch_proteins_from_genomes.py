from Bio import Entrez, SeqIO

# Set your email (required by NCBI)
Entrez.email = "your_email@example.com"

# Open the file containing multiple genomic IDs
with open("essential_genome_ids.txt") as id_file:
    genomic_ids = [line.strip() for line in id_file]

# Open a file to save all protein sequences
with open("proteins_from_genome.fasta", "w") as output_file:

    for genomic_id in genomic_ids:

        # Fetch the GenBank file for the genomic sequence
        handle = Entrez.efetch(db="nucleotide", id=genomic_id, rettype="gb", retmode="text")
        record = SeqIO.read(handle, "genbank")

        for feature in record.features:
            if feature.type == "CDS":
                if 'translation' in feature.qualifiers:
                    protein_seq = feature.qualifiers['translation'][0]
                    gene_name = feature.qualifiers.get('gene', ['unknown_gene'])[0]
                    
                    # Write the protein sequence in FASTA format
                    output_file.write(f">{genomic_id}_{gene_name}\n{protein_seq}\n")

        handle.close()

print("Protein sequences have been saved to proteins_from_genome.fasta")