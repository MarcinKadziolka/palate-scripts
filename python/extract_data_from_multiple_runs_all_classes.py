import os
import csv

# Define the base directory
base_dir = "/home/gmkadzio/dgm-eval/all_classes_fld"

# Define the columns for the CSV file
columns = ["model", "classes", "run", "cmmd_train", "cmmd_test", "mianownik_test", "pierwszy_skladnik", "drugi_skladnik", "k_xx", "k_yy", "k_xy", "MMM_cmmd"]
columns = ["model", "classes", "run", "fld"]
# Define the output CSV file
output_csv = "output_results.csv"

# Open the CSV file for writing
with open(output_csv, mode='w', newline='') as csv_file:
    writer = csv.DictWriter(csv_file, fieldnames=columns)
    writer.writeheader()

    # Traverse the directory structure
    for model in os.listdir(base_dir):
        model_dir = os.path.join(base_dir, model)
        if os.path.isdir(model_dir):
            for k in os.listdir(model_dir):
                k_dir = os.path.join(model_dir, k)
                if os.path.isdir(k_dir):
                    for run in os.listdir(k_dir):
                        run_dir = os.path.join(k_dir, run)
                        if os.path.isdir(run_dir):
                            # Look for the txt file in the run directory
                            for file in os.listdir(run_dir):
                                if file.endswith(".txt"):
                                    txt_file = os.path.join(run_dir, file)
                                    # Read the values from the txt file
                                    values = {}
                                    with open(txt_file, 'r') as f:
                                        for line in f:
                                            key, value = line.strip().split(": ")
                                            values[key] = float(value)
                                    # Write the row to the CSV file
                                    writer.writerow({
                                        "model": model,
                                        "classes": k,
                                        "run": run,
                                        "fld": values.get("fld", None),
                                        #"cmmd_train": values.get("cmmd_train", None),
                                        #"cmmd_test": values.get("cmmd_test", None),
                                        #"mianownik_test": values.get("mianownik_test", None),
                                        #"pierwszy_skladnik": values.get("pierwszy_skladnik", None),
                                        #"drugi_skladnik": values.get("drugi_skladnik", None),
                                        #"MMM_cmmd": values.get("MMM_cmmd", None),
                                        #"k_xx": values.get("k_xx", None),
                                        #"k_xy": values.get("k_xy", None),
                                        #"k_yy": values.get("k_yy", None)
                                    })

print(f"Data has been written to {output_csv}")
