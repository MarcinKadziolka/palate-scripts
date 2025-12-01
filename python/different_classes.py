import os
import shutil
import argparse
import numpy as np

def prepare_folders(model_name, source_root, dest_root):
    print(f"Starting preparation for model: {model_name}")
    source_path = os.path.join(source_root, f"CIFAR10-{model_name}")
    dest_path = os.path.join(dest_root, f"CIFAR10-{model_name}")
    os.makedirs(dest_path, exist_ok=True)

    # Define class folders (0..9)
    class_folders = sorted([str(i) for i in range(10)])
    n_samples_per_class = 1000
    total_samples_target = 10000

    # Step 1: Select fixed 1000 samples per class
    selected_samples = {}
    for cls in class_folders:
        cls_source_path = os.path.join(source_path, cls)
        if not os.path.exists(cls_source_path):
            raise ValueError(f"Missing class folder: {cls_source_path}")

        all_files = os.listdir(cls_source_path)
        if len(all_files) < n_samples_per_class:
            raise ValueError(f"Class {cls} in {model_name} has {len(all_files)} images, need {n_samples_per_class}.")

        selected_samples[cls] = np.random.choice(all_files, n_samples_per_class, replace=False).tolist()

    # Step 2: Create subsets for C = 1..10
    for C in range(1, 11):
        subset_classes = class_folders[:C]
        dup_factor = total_samples_target // (n_samples_per_class * C)
        print(f"Creating subset with {C} classes, dup_factor={dup_factor}")

        subset_path = os.path.join(dest_path, f"{C}_classes")
        os.makedirs(subset_path, exist_ok=True)

        images_to_copy = []
        for cls in subset_classes:
            imgs = selected_samples[cls] * dup_factor
            images_to_copy.extend((img, cls) for img in imgs)

        # Copy images
        for idx, (img, cls) in enumerate(images_to_copy):
            src_file = os.path.join(source_path, cls, img)
            if not os.path.exists(src_file):
                print(f"Warning: {src_file} missing.")
                continue
            unique_filename = f"{cls}_{idx}_{img}"
            shutil.copy(src_file, os.path.join(subset_path, unique_filename))

        print(f"Finished: {len(images_to_copy)} images in {subset_path}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Prepare CIFAR10 subsets varying number of classes with fixed sample size.")
    args = parser.parse_args()

    SOURCE_ROOT = "/shared/sets/datasets/CIFAR10-dgm_eval"
    DEST_ROOT = "/shared/sets/datasets/PALATE_FIG_6_DIFFERENT_CLASSES"

    models = ["StyleGAN-XL", "PFGMPP", "MHGAN", "StyleGAN2-ada", "BigGAN-Deep"]
    for model_name in models:
        prepare_folders(model_name, SOURCE_ROOT, DEST_ROOT)
