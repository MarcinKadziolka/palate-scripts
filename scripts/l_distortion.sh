#!/bin/bash
#SBATCH --job-name=debugging
#SBATCH --qos=normal
#SBATCH --partition=rtx4090
#SBATCH --mem=32G
#SBATCH --gres=gpu:1

cd $HOME/continued
export PATH=$HOME/miniconda3/bin:$PATH
source activate 
conda activate continued_cuda

TEST_PATH="/shared/sets/datasets/CIFAR10-dgm_eval/CIFAR10/test"
TRAIN_PATH="/shared/sets/datasets/CIFAR10-dgm_eval/interpolation_all/PFGMPP/100%train" 

TEST_PATH="/shared/sets/datasets/CIFAR10-dgm_eval_repr_kdd/dinov3_vitl16_pretrain_lvd1689m-8aa4cbdd_CIFAR10_test_10000.npz"
TRAIN_PATH="/shared/sets/datasets/CIFAR10-dgm_eval_repr_kdd/dinov3_vitl16_pretrain_lvd1689m-8aa4cbdd_PFGMPP_100%train_10000.npz"


DATASET_BASE="/shared/sets/datasets/CIFAR10-dgm_eval/interpolation_all/PFGMPP"
MODEL="dinov3"
OUTPUT_BASE="debugging"
echo "TRAIN:" $TRAIN_PATH
echo "TEST:" $TEST_PATH 
echo "GEN:" $GEN_PATH

MODEL="PFGMPP"
DISTORTIONS=("none" "posterize" "blur" "resize" "center_crop30" "center_crop28" "color_distort" "elastic_transform" "jpg75" "jpg90")

DISTORTIONS=("none" "blur" "center_crop30" "posterize" "jpg75")
DISTORTIONS=("elastic_transform")
for train_folder in "$DATASET_BASE"/*train; do
    train_folder="/shared/sets/datasets/CIFAR10-dgm_eval/interpolation_all/PFGMPP/80%train"
    TRAIN_NAME=$(basename "$train_folder")
    for distortion in "${DISTORTIONS[@]}"; do
        OUTPUT_DIR="$OUTPUT_BASE/$MODEL/$TRAIN_NAME/$distortion" 
        mkdir -p "$OUTPUT_DIR" 
        echo "Applying distortion: $distortion to folder: $train_folder" 
        echo "Output folder: $OUTPUT_DIR" 
        python main.py "$TRAIN_PATH" "$TEST_PATH" "$train_folder" \
            --output_dir "$OUTPUT_DIR" \
            --model dinov3 \
            --device cuda \
            --batch_size 256 \
            --nsample 10000 \
            --sigma 10.5 \
            --tau -300 \
            --distortion "$distortion" \
            --load_npz
        echo "Completed evaluation with distortion $distortion"
        exit 0
    done
done
