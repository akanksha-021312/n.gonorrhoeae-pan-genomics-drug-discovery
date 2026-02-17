import pandas as pd

# Load the gene_presence_absence.csv file
file_path = 'path_to_your_file/gene_presence_absence.csv'
df = pd.read_csv(file_path, low_memory=False)

# Identify columns that contain presence/absence data (assuming they start after the 14th column)
presence_absence_columns = df.columns[14:]

# Set a threshold for core genes (e.g., present in 95% or more genomes)
core_threshold = 0.95
total_genomes = len(presence_absence_columns)

# Define criteria for core genes (present in >= 95% of genomes)
core_genes = df[df[presence_absence_columns].apply(lambda row: row.notna().sum() / total_genomes >= core_threshold, axis=1)]

# Define criteria for accessory genes (present in < 95% of genomes)
accessory_genes = df[df[presence_absence_columns].apply(lambda row: row.notna().sum() / total_genomes < core_threshold, axis=1)]

# Save core and accessory genes to separate CSV files
core_genes.to_csv('core_genes.csv', index=False)
accessory_genes.to_csv('accessory_genes.csv', index=False)

# Print summary
print(f"Core genes: {core_genes.shape[0]}")
print(f"Accessory genes: {accessory_genes.shape[0]}")
