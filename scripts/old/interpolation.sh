#!/bin/bash
#SBATCH --job-name=interpolations
#SBATCH --qos=normal
#SBATCH --partition=student
#SBATCH --mem=32G
#SBATCH --gres=gpu:1

cd $HOME/dgm-eval
export PATH=$HOME/miniconda3/bin:$PATH
source activate dgm-eval

REPS_TRAIN_PATH="/shared/sets/datasets/CIFAR10-dgm_eval_reps/dinov2/train"
REPS_TEST_PATH="/shared/sets/datasets/CIFAR10-dgm_eval_reps/dinov2/test"
DATASET_BASE="/shared/sets/datasets/CIFAR10-dgm_eval/CIFAR10-PFGMPP/interpolation"
OUTPUT_BASE="$HOME/dgm-eval/interpolation"

MODEL="PFGMPP"
METRICS=("fld" "fd" "ct" "authpct" "cmmd")
for train_folder in "$DATASET_BASE"/*train; do
    TRAIN_NAME=$(basename "$train_folder")
    for metric in "${METRICS[@]}"; do
            OUTPUT_DIR="$OUTPUT_BASE/$MODEL/$metric/$TRAIN_NAME"
            mkdir -p "$OUTPUT_DIR"
            
            python -m dgm_eval "$REPS_TRAIN_PATH" "$train_folder" \
                --test_path "$REPS_TEST_PATH" \
                --output_dir "$OUTPUT_DIR" \
                --model dinov2 \
                --metrics "$metric" \
                --device cuda \
                --batch_size 256 \
                --nsample 10000 \
                --no-load \
                --use_test_train_repr \
                --eval_feat gap
    done
done
echo "Done"
