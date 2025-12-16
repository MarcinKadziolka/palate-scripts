#!/bin/bash
#SBATCH --job-name=dinov3_representations
#SBATCH --qos=normal
#SBATCH --partition=rtx4090
#SBATCH --mem=32G
#SBATCH --gres=gpu:1

# Compute the representations for future usage.

cd $HOME/continued
export PATH=$HOME/miniconda3/bin:$PATH
source activate continued_cuda
which python

echo 'Running script'

REPS_TRAIN_PATH="/shared/sets/datasets/CIFAR10-dgm_eval/CIFAR10/train"
REPS_TEST_PATH="/shared/sets/datasets/CIFAR10-dgm_eval/CIFAR10/test"
echo $REPS_TRAIN_PATH
echo $REPS_TEST_PATH

MODELS=("StyleGAN-XL" "PFGMPP" "MHGAN" "StyleGAN2-ada" "BigGAN-Deep" "ACGAN-Mod" "WGAN-GP" "LOGAN" "ReACGAN" "WGAN-GP")
REPR_MODEL="dinov3"
for model in "${MODELS[@]}"; do

    GEN_PATH="/shared/sets/datasets/CIFAR10-dgm_eval/CIFAR10-$model"

    python main.py "$REPS_TRAIN_PATH" "$REPS_TEST_PATH" "$GEN_PATH" \
    --output_dir "./dinov3_output" \
    --exp_dir "metrics_sigma10" \
    --model dinov3 \
    --device cuda \
    --batch_size 256 \
    --nsample 10000 \
    --load \
    --repr_dir "/shared/sets/datasets/CIFAR10-dgm_eval_repr" \
    --sigma 10
done
echo 'Task completed'
