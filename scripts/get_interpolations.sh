#!/bin/bash
#SBATCH --job-name=dinov3_interpolations
#SBATCH --qos=normal
#SBATCH --partition=rtx4090
#SBATCH --mem=32G
#SBATCH --gres=gpu:1

set -euo pipefail

cd "$HOME/continued"

export PATH="$HOME/miniconda3/bin:$PATH"
source activate continued_cuda

echo "Using python: $(which python)"
echo "Running script"

REPS_TRAIN_PATH="/shared/sets/datasets/CIFAR10-dgm_eval/CIFAR10/train"
REPS_TEST_PATH="/shared/sets/datasets/CIFAR10-dgm_eval/CIFAR10/test"

INTERP_ROOT="/shared/sets/datasets/CIFAR10-dgm_eval/interpolation_all"

echo "Train path: $REPS_TRAIN_PATH"
echo "Test path : $REPS_TEST_PATH"
echo "Interpolation root: $INTERP_ROOT"

# Loop:
# interpolation_all/<method>/<subfolder>
for method_dir in "$INTERP_ROOT"/*; do
    [ -d "$method_dir" ] || continue

    method_name="$(basename "$method_dir")"

    for gen_path in "$method_dir"/*; do
        [ -d "$gen_path" ] || continue

        sub_name="$(basename "$gen_path")"

        echo "----------------------------------------"
        echo "Method     : $method_name"
        echo "Subfolder  : $sub_name"
        echo "GEN_PATH   : $gen_path"
        echo "----------------------------------------"
        
        python main.py \
            "$REPS_TRAIN_PATH" \
            "$REPS_TEST_PATH" \
            "$gen_path" \
            --output_dir "./dinov3_interpolations" \
            --exp_dir "${method_name}/${sub_name}" \
            --model dinov3 \
            --device cuda \
            --batch_size 256 \
            --nsample 10000 \
            --save \
            --load \
            --repr_dir "/shared/sets/datasets/CIFAR10-dgm_eval_repr"
    done
done

echo "Task completed"

