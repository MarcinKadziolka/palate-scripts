import os
import csv
import re

def extract_metrics_from_file(file_path):
    """Extract all metric values from a given file."""
    metrics = {}
    with open(file_path, 'r') as f:
        lines = f.readlines()
        for line in lines:
            parts = line.strip().split(': ')
            if len(parts) == 2:
                key, value = parts[0], parts[1]
                try:
                    metrics[key] = round(float(value), 6)
                except ValueError:
                    continue
    return metrics

def process_directory(base_path, fld_csv, cmmd_csv):
    """Walk through directories, extract metrics, and save to separate CSVs."""
    fld_data = []
    cmmd_data = []
    pattern = re.compile(r'copying_all_classes_(fld|cmmd)')
    
    fld_headers = ['model', 'n_unique_samples_cls', 'fld']
    cmmd_headers = ['model', 'n_unique_samples_cls']
    all_cmmd_metrics = set()
    temp_cmmd_data = []
    
    for root, _, files in os.walk(base_path):
        match = pattern.search(root)
        if not match:
            continue
        
        metric = match.group(1)
        path_parts = root.split(os.sep)
        if len(path_parts) < 3:
            continue
        
        model = path_parts[-2]
        n_unique_samples_cls = path_parts[-1]
        
        for file in files:
            if file.endswith('.txt'):
                file_path = os.path.join(root, file)
                metrics = extract_metrics_from_file(file_path)
                if metrics:
                    if metric == 'fld' and 'fld' in metrics:
                        fld_data.append([model, n_unique_samples_cls, metrics['fld']])
                    elif metric == 'cmmd':
                        all_cmmd_metrics.update(metrics.keys())
                        temp_cmmd_data.append([model, n_unique_samples_cls, metrics])
    
    cmmd_headers.extend(sorted(all_cmmd_metrics))
    
    with open(fld_csv, 'w', newline='') as f:
        writer = csv.writer(f)
        writer.writerow(fld_headers)
        writer.writerows(fld_data)
    
    with open(cmmd_csv, 'w', newline='') as f:
        writer = csv.writer(f)
        writer.writerow(cmmd_headers)
        
        for model, n_samples, metrics in temp_cmmd_data:
            row = [model, n_samples] + [metrics.get(metric, '') for metric in sorted(all_cmmd_metrics)]
            writer.writerow(row)

# Example usage
base_path = os.path.expanduser('~/dgm-eval/')
fld_csv = 'fld.csv'
cmmd_csv = 'cmmd.csv'
process_directory(base_path, fld_csv, cmmd_csv)
