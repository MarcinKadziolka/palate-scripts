import os
import shutil
import argparse
import numpy as np

def prepare_folders(model_name, source_root, dest_root):
    print(f"Starting preparation for model: {model_name}")
    source_path = os.path.join(source_root, f"CIFAR10-{model_name}")
    dest_path = os.path.join(dest_root, f"CIFAR10-{model_name}")
    os.makedirs(dest_path, exist_ok=True)
    print(f"Destination path created: {dest_path}")
    
    # Determine number of classes
    class_folders = sorted([str(i) for i in range(10)])
    num_classes = len(class_folders)
    print(f"Detected {num_classes} class folders.")
    
    # Count images per class
    class_image_counts = {cls: len(os.listdir(os.path.join(source_path, cls))) for cls in class_folders}
    print(f"Image counts per class: {class_image_counts}")
    
    for k in range(1, num_classes + 1):
        print(f"Processing subset for {k} classes...")
        subset_path = os.path.join(dest_path, str(k))
        os.makedirs(subset_path, exist_ok=True)
        print(f"Created subset folder: {subset_path}")
        
        # Select k classes
        selected_classes = class_folders[:k]
        images_per_class = 10000 // k  # Ensuring total images per subset is 10k
        print(f"Selected classes: {selected_classes}, Images per class: {images_per_class}")
        
        all_selected_images = []
        for cls in selected_classes:
            cls_source_path = os.path.join(source_path, cls)
            images = np.random.choice(os.listdir(cls_source_path), images_per_class, replace=False).tolist()
            all_selected_images.extend([(cls, img) for img in images])
            print(f"Selected {len(images)} images from class {cls}")
        
        # Adjust in case of rounding issues
        extra_needed = 10000 - len(all_selected_images)
        if extra_needed > 0:
            last_class = selected_classes[-1]
            last_class_source = os.path.join(source_path, last_class)
            additional_images = np.random.choice(os.listdir(last_class_source), extra_needed, replace=False).tolist()
            all_selected_images.extend([(last_class, img) for img in additional_images])
            print(f"Added {extra_needed} more images from class {last_class} to reach 10k.")
        
        # Copy images
        for cls, img in all_selected_images:
            cls_source_path = os.path.join(source_path, cls, img)
            shutil.copy(cls_source_path, os.path.join(subset_path, img))
        print(f"Finished copying {len(all_selected_images)} images to {subset_path}")
        

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Prepare CIFAR10 subsets with balanced classes and generate SLURM scripts.")
    parser.add_argument("model_name", type=str, help="Name of the model")
    args = parser.parse_args()
    
    SOURCE_ROOT = "/shared/sets/datasets/CIFAR10-dgm_eval"
    DEST_ROOT = "/shared/sets/datasets/PALATE_FIG_6_all_classes"
    
    prepare_folders(args.model_name, SOURCE_ROOT, DEST_ROOT)
