#!/bin/bash
#SBATCH --job-name=ACGAN-Mod
#SBATCH --qos=normal
#SBATCH --partition=rtx4090
#SBATCH --mem=32G
#SBATCH --gres=gpu:1

echo "Script started"

cd $HOME/continued
export PATH=$HOME/miniconda3/bin:$PATH
source activate 
conda activate continued_cuda

echo "Using python:"
which python


TRAIN_PATH="/shared/sets/datasets/CIFAR10-dgm_eval/CIFAR10/train"
TEST_PATH="/shared/sets/datasets/CIFAR10-dgm_eval/CIFAR10/test"
GEN_PATH="/shared/sets/datasets/CIFAR10-dgm_eval/CIFAR10-ACGAN-Mod"
OUTPUT_DIR="./acgan_mod"
MODEL="dinov3"
echo "TRAIN:" $TRAIN_PATH
echo "TEST:" $TEST_PATH
echo "GENL:" $GEN_PATH

python main.py "$TRAIN_PATH" "$TEST_PATH" "$GEN_PATH" \
--output_dir "$OUTPUT_DIR" \
--model "$MODEL" \
--device cuda \
--batch_size 256 \
--nsample 10000 \
--sigma 0.01 \
--load

echo 'Script finished'
