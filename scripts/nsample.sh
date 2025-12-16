#!/bin/bash
#SBATCH --job-name=ACGAN-Mod
#SBATCH --qos=normal
#SBATCH --partition=rtx4090
#SBATCH --mem=32G
#SBATCH --gres=gpu:1

cd $HOME/continued
export PATH=$HOME/miniconda3/bin:$PATH
source activate continued_cuda
which python
which python3

echo 'Running script'

REPS_TRAIN_PATH="/shared/sets/datasets/CIFAR10-dgm_eval/CIFAR10/train"
REPS_TEST_PATH="/shared/sets/datasets/CIFAR10-dgm_eval/CIFAR10/test"
echo $REPS_TRAIN_PATH
echo $REPS_TEST_PATH

MODELS=("StyleGAN-XL" "PFGMPP" "MHGAN" "StyleGAN2-ada" "BigGAN-Deep" "ACGAN-Mod" "WGAN-GP" "LOGAN" "ReACGAN" "WGAN-GP")
NSAMPLE=(100 1000 2000 5000 10000)
for model in "${MODELS[@]}"; do
    GEN_PATH="/shared/sets/datasets/CIFAR10-dgm_eval/CIFAR10-$model"
    OUTPUT_DIR="./dinov3_output/$model"
    for nsample in "${NSAMPLE[@]}"; do
        python main.py "$REPS_TRAIN_PATH" "$REPS_TEST_PATH" "$GEN_PATH" \
        --output_dir "$OUTPUT_DIR" \
        --model dinov3 \
        --device cuda \
        --batch_size 256 \
        --nsample $nsample
    done
done
echo 'Task completed'
