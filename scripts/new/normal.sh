#!/bin/bash
#SBATCH --job-name=ACGAN-Mod
#SBATCH --qos=normal
#SBATCH --partition=rtx4090
#SBATCH --mem=32G
#SBATCH --gres=gpu:1

cd $HOME/continued
export PATH=$HOME/miniconda3/bin:$PATH
source activate palate

echo 'Running script'

REPS_TRAIN_PATH="/shared/sets/datasets/CIFAR10-dgm_eval/CIFAR10/train"
REPS_TEST_PATH="/shared/sets/datasets/CIFAR10-dgm_eval/CIFAR10/test"
REAL_GEN_PATH="/shared/sets/datasets/CIFAR10-dgm_eval/CIFAR10-ACGAN-Mod"
OUTPUT_DIR="./output"
echo $REPS_TRAIN_PATH
echo $REPS_TEST_PATH

python main.py "$REPS_TRAIN_PATH" "$REPS_TEST_PATH" "$REAL_GEN_PATH" \
--output_dir "$OUTPUT_DIR" \
--model dinov3 \
--device cuda \
--batch_size 256 \
--nsample 10000 \
--save 

echo 'Task completed'

