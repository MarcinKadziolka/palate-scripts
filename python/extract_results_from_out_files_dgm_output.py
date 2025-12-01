import os
import re
import csv

# Define the base directory containing all model directories
base_dir = 'figure_6_results'

# Define the output CSV file
output_csv = 'figure_6_results.csv'

# Define the headers for the CSV file
headers = ['Model', 'Number of Classes', 'cmmd_train', 'cmmd_test', 'mianownik_test', 'pierwszy_skladnik', 'drugi_skladnik', 'MMM_cmmd']

# Regular expression to extract the values
pattern = re.compile(r'(cmmd_train|cmmd_test|mianownik_test|pierwszy_skladnik|drugi_skladnik|MMM_cmmd):\s*([\d.]+)')

# Open the CSV file for writing
with open(output_csv, mode='w', newline='') as csv_file:
    writer = csv.writer(csv_file)
    writer.writerow(headers)
    
    # Iterate over each model directory in the base directory
    for model_dir in os.listdir(base_dir):
        model_path = os.path.join(base_dir, model_dir)
        
        # Check if it's a directory (to skip files like .DS_Store or others)
        if os.path.isdir(model_path):
            print(f"Processing model: {model_dir}")
            
            # Iterate over each .out file in the model directory
            for filename in os.listdir(model_path):
                if filename.endswith('.out'):
                    # Extract the model number and number of classes
                    model_number = filename.split('_')[1].split('.')[0]
                    if model_number == 'REAL':
                        num_classes = 10
                    else:
                        num_classes = int(model_number)
                    
                    # Read the content of the .out file
                    with open(os.path.join(model_path, filename), 'r') as file:
                        content = file.read()
                    
                    # Find all matches using the regular expression
                    matches = pattern.findall(content)
                    
                    # Create a dictionary to store the extracted values
                    values = {key: float(value) for key, value in matches}
                    
                    # Write the extracted values to the CSV file
                    writer.writerow([
                        model_dir,  # Model name (e.g., MHGAN)
                        num_classes,  # Number of classes
                        values.get('cmmd_train', ''),  # cmmd_train
                        values.get('cmmd_test', ''),  # cmmd_test
                        values.get('mianownik_test', ''),  # mianownik_test
                        values.get('pierwszy_skladnik', ''),  # pierwszy_skladnik
                        values.get('drugi_skladnik', ''),  # drugi_skladnik
                        values.get('MMM_cmmd', '')  # MMM_cmmd
                    ])

print(f"Data has been successfully written to {output_csv}")
