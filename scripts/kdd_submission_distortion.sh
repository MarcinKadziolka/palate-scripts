#!/bin/bash

REPR_TEST_PATH="/shared/sets/datasets/CIFAR10-dgm_eval_repr_kdd/dinov3_vitl16_pretrain_lvd1689m-8aa4cbdd_CIFAR10_test_10000.npz"
REPR_TRAIN_PATH="/shared/sets/datasets/CIFAR10-dgm_eval_repr_kdd/dinov3_vitl16_pretrain_lvd1689m-8aa4cbdd_PFGMPP_100%train_10000.npz"

DATASET_BASE="/shared/sets/datasets/CIFAR10-dgm_eval/interpolation_all/PFGMPP"

OUTPUT_BASE="$HOME/distortion_results_train_test_from_repr_gen_from_interpolations"
MODEL="PFGMPP"

DISTORTIONS=(
    "none"
    "posterize"
    "blur"
    "resize"
    "center_crop30"
    "center_crop28"
    "color_distort"
    "elastic_transform"
    "jpg75"
    "jpg90"
)

mkdir -p kdd_submission
INDEX=0
for train_folder in "$DATASET_BASE"/*train; do
    train_folder="/shared/sets/datasets/CIFAR10-dgm_eval/interpolation_all/PFGMPP/0%train"
    TRAIN_NAME=$(basename "$train_folder")

    for distortion in "${DISTORTIONS[@]}"; do
        OUTPUT_DIR="$OUTPUT_BASE/$MODEL/$TRAIN_NAME/$distortion"

        JOB_FILE="kdd_submission/$INDEX.sh"

        cat > "$JOB_FILE" <<EOF
#!/bin/bash
#SBATCH --job-name=kdd_submission
#SBATCH --qos=batch
#SBATCH --partition=rtx4090_batch
#SBATCH --mem=32G
#SBATCH --gres=gpu:1

echo "Train npz: $REPR_TRAIN_PATH"
echo "Test npz: $REPR_TRAIN_PATH"
echo "Distortion: $distortion"
echo "Output dir: $OUTPUT_DIR"

export PATH=\$HOME/miniconda3/bin:\$PATH
source activate
conda activate continued_cuda

mkdir -p "$OUTPUT_DIR"

cd \$HOME/continued

python main.py \
    "$REPR_TRAIN_PATH" \
    "$REPR_TEST_PATH" \
    "$train_folder" \
    --output_dir "$OUTPUT_DIR" \
    --model dinov3 \
    --device cuda \
    --batch_size 256 \
    --nsample 10000 \
    --sigma 10.5 \
    --tau -300 \
    --distortion "$distortion" \
    --load_npz

echo "Completed evaluation for $TRAIN_NAME with distortion $distortion"
EOF

        chmod +x "$JOB_FILE"
        sbatch "$JOB_FILE"
        INDEX=$((INDEX + 1))
    done
done

