REPS_TRAIN_PATH="/shared/sets/datasets/CIFAR10-dgm_eval_reps/dinov2/train"
REPS_TEST_PATH="/shared/sets/datasets/CIFAR10-dgm_eval_reps/dinov2/test"
DATASET_BASE="/shared/sets/datasets/CIFAR10-dgm_eval/CIFAR10-PFGMPP/interpolation"
OUTPUT_BASE="$HOME/iccv_submission"

MODEL="PFGMPP"
DISTORTIONS=("none" "posterize" "blur" "resize" "center_crop30" "center_crop28" "color_distort" "elastic_transform" "jpg75" "jpg90")
METRICS=("fid" "ct" "authpct" "m_palate" "fld" "ct_modified")
mkdir -p "submission"
INDEX=0
for train_folder in "$DATASET_BASE"/*train; do
    TRAIN_NAME=$(basename "$train_folder")
    for metric in "${METRICS[@]}"; do
        for distortion in "${DISTORTIONS[@]}"; do
            OUTPUT_DIR="$OUTPUT_BASE/$MODEL/$metric/$TRAIN_NAME/$distortion"
	    echo "#!/bin/bash
#SBATCH --job-name=iccv_submission
#SBATCH --qos=batch
#SBATCH --partition=rtx4090_batch
#SBATCH --mem=32G
#SBATCH --gres=gpu:1
mkdir -p "$OUTPUT_DIR"
echo "Applying distortion: $distortion to folder: $train_folder"
            
cd \$HOME/dgm-eval
export PATH=\$HOME/miniconda3/bin:\$PATH
source activate dgm-eval
python -m dgm_eval "$REPS_TRAIN_PATH" "$train_folder" --test_path "$REPS_TEST_PATH" --output_dir "$OUTPUT_DIR" --model dinov2 --metrics "$metric" --device cuda --batch_size 256 --nsample 10000 --no-load --use_train_test_repr --distortion "$distortion"" > submission/$INDEX.sh
sbatch submission/$INDEX.sh
INDEX=$((INDEX+1)) 
            echo "Completed evaluation for model $MODEL with distortion $distortion for metric $metric"
        done
    done
done
