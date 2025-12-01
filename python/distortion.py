import os
import csv
from collections import defaultdict

# Define the base directory
base_dir = "/home/gmkadzio/iccv_submission/PFGMPP"
output_file = "metrics_summary.csv"

# Initialize data storage
csv_header = ["model", "%train", "distortion"]
all_metrics = set()
metrics_data = defaultdict(lambda: {"model": "PFGMPP"})  # Stores all metrics for each (%train, distortion) pair

# First pass: Collect all metric names and data
for root, _, files in os.walk(base_dir):
    for file in files:
        if file.endswith(".txt"):
            file_path = os.path.join(root, file)

            # Extract model, %train, and distortion from the path
            parts = root.split("/")
            try:
                percent_train = parts[-2]   # e.g., "20%train"
                distortion = parts[-1]      # e.g., "color_distort"
            except IndexError:
                continue  # Skip unexpected folder structures

            key = (percent_train, distortion)  # Unique identifier for each row

            # Read and parse the file
            with open(file_path, "r") as f:
                for line in f:
                    key_name, value = line.split(": ")
                    key_name = key_name.strip()
                    metrics_data[key][key_name] = float(value.strip())
                    all_metrics.add(key_name)  # Collect metric names dynamically

# Second pass: Write to CSV
csv_header.extend(sorted(all_metrics))  # Ensure consistent column order

with open(output_file, "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerow(csv_header)  # Write header

    for (percent_train, distortion), metrics in metrics_data.items():
        row = ["PFGMPP", percent_train, distortion] + [metrics.get(metric, "") for metric in csv_header[3:]]
        writer.writerow(row)

print(f"CSV file saved: {output_file}")

