import os
import csv

# Define the root directory using the full path
root_dir = os.path.expanduser('~/dgm-eval/copying_fld')  # Expands ~ to the full home directory path

# Define the output CSV file
output_csv = 'new_cmmd_values.csv'

# Define the fields to extract from the text files
fields = ['cmmd_train', 'cmmd_test', 'mianownik_test', 'pierwszy_skladnik', 'drugi_skladnik', 'k_xx', 'k_yy', 'k_xy', 'MMM_cmmd']
fields = ["fld"]
# Initialize the CSV file with headers
with open(output_csv, mode='w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['Model', 'class range'] + fields)

# Traverse through the directory structure
for model in os.listdir(root_dir):
    model_dir = os.path.join(root_dir, model)
    if os.path.isdir(model_dir):
        for subfolder in os.listdir(model_dir):
            subfolder_dir = os.path.join(model_dir, subfolder)
            if os.path.isdir(subfolder_dir):
                for file in os.listdir(subfolder_dir):
                    if file.endswith('.txt'):
                        file_path = os.path.join(subfolder_dir, file)
                        with open(file_path, 'r') as f:
                            lines = f.readlines()
                            values = {}
                            for line in lines:
                                for field in fields:
                                    if field in line:
                                        values[field] = line.split(': ')[1].strip()
                            # Write the extracted values to the CSV file
                            with open(output_csv, mode='a', newline='') as file:
                                writer = csv.writer(file)
                                writer.writerow([model, subfolder] + [values.get(field, '') for field in fields])

print(f"Data has been saved to {output_csv}")
