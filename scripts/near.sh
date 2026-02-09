#!/bin/bash
#SBATCH --job-name=debugging
#SBATCH --qos=normal
#SBATCH --partition=rtx4090
#SBATCH --mem=32G
#SBATCH --gres=gpu:1

cd $HOME/PALATE
export PATH=$HOME/miniconda3/bin:$PATH
source activate 
conda activate /shared/results/z1191743/envs/palate_env


TEST_PATH="/shared/sets/datasets/CIFAR10-dgm_eval_repr_kdd/dinov3_vitl16_pretrain_lvd1689m-8aa4cbdd_CIFAR10_test_10000.npz"
TRAIN_PATH="/shared/sets/datasets/CIFAR10-dgm_eval_repr_kdd/dinov3_vitl16_pretrain_lvd1689m-8aa4cbdd_PFGMPP_100%train_10000.npz"
GEN_PATH="/shared/sets/datasets/CIFAR10-dgm_eval_repr_kdd/dinov3_vitl16_pretrain_lvd1689m-8aa4cbdd_PFGMPP_100%train_10000.npz"

TEST_PATH="/shared/sets/datasets/CIFAR10-dgm_eval/CIFAR10/test"
TRAIN_PATH="/shared/sets/datasets/CIFAR10-dgm_eval/interpolation_all/PFGMPP/100%train" 
GEN_PATH="/shared/sets/datasets/CIFAR10-dgm_eval/interpolation_all/PFGMPP/100%train" 


DATASET_BASE="/shared/sets/datasets/CIFAR10-dgm_eval/interpolation_all/PFGMPP"
MODEL="dinov3"
OUTPUT_BASE="debugging"
echo "TRAIN:" $TRAIN_PATH
echo "TEST:" $TEST_PATH 
echo "GEN:" $GEN_PATH

python main.py "$TRAIN_PATH" "$TEST_PATH" "$GEN_PATH" \
    --model dinov3 \
    --device cuda \
    --batch_size 256 \
    --nsample 10000 \
    --sigma 10.5 \
    --tau -300 \
    --dino_ckpt "/shared/results/gmdziarm/dinov3_vitl16_pretrain_lvd1689m-8aa4cbdd.pth"
