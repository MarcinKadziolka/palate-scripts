#!/bin/bash
#SBATCH --job-name=cmmd_fig_6_duplication
#SBATCH --qos=normal
#SBATCH --partition=rtx4090
#SBATCH --mem=32G
#SBATCH --gres=gpu:1

cd $HOME/dgm-eval
export PATH=$HOME/miniconda3/bin:$PATH
source activate dgm-eval

echo 'Running script'

REPS_TRAIN_PATH="/shared/sets/datasets/CIFAR10-dgm_eval/CIFAR10/train"
REPS_TEST_PATH="/shared/sets/datasets/CIFAR10-dgm_eval/CIFAR10/test"

REPS_TEST_PATH="/shared/sets/datasets/CIFAR10-dgm_eval/CIFAR10-LOGAN"


python -m dgm_eval "$REPS_TRAIN_PATH" "$REAL_GEN_PATH" \
--test_path "$REPS_TEST_PATH" \
--output_dir "$OUTPUT_DIR" \
--model dinov2 \
--metrics "$metric" \
--device cuda \
--batch_size 256 \
--nsample 10000 \
--no-load \

echo 'Task completed'

