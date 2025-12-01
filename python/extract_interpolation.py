import os
import pandas as pd
import re

def extract_metrics_from_txt(file_path):
    metrics = {}
    with open(file_path, 'r') as file:
        for line in file:
            # Match lines with metric names and values
            match = re.match(r"(\S+):\s+([\d.e-]+)", line)
            if match:
                metric_name, metric_value = match.groups()
                metrics[metric_name] = float(metric_value)
    return metrics

def process_directory(root_dir, model_name="PFGMPP"):
    data = {}
    for distortion in os.listdir(root_dir):
        distortion_path = os.path.join(root_dir, distortion)
        if not os.path.isdir(distortion_path):
            continue
        
        for train_folder in os.listdir(distortion_path):
            train_path = os.path.join(distortion_path, train_folder)
            if not os.path.isdir(train_path):
                continue
            
            train_percentage = train_folder.replace("%train", "").strip()
            
            # Create a unique key for each model and %train combination
            key = (model_name, train_percentage)
            if key not in data:
                data[key] = {"model": model_name, "%train": train_percentage}
            
            for file in os.listdir(train_path):
                if file.endswith(".txt"):
                    file_path = os.path.join(train_path, file)
                    metrics = extract_metrics_from_txt(file_path)
                    if metrics:
                        # Update the row with new metrics
                        data[key].update(metrics)
    
    # Convert the dictionary to a list of rows
    data_list = list(data.values())
    
    # Create a DataFrame from the collected data
    df = pd.DataFrame(data_list)
    
    # Ensure all columns are present, even if some metrics are missing
    all_columns = ["model", "%train"] + sorted(set().union(*(d.keys() for d in data_list)) - {"model", "%train"})
    df = df.reindex(columns=all_columns)
    
    # Save the DataFrame to a CSV file
    df.to_csv("metrics_output.csv", index=False)
    print("CSV file saved as metrics_output.csv")

# Run the function with the given directory
root_directory = "/home/gmkadzio/dgm-eval/interpolation/PFGMPP"
process_directory(root_directory)
