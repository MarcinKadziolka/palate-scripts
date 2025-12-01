#!/bin/bash
#SBATCH --job-name=std_all_classes_fig_6
#SBATCH --qos=normal
#SBATCH --partition=student
#SBATCH --mem=32G
#SBATCH --gres=gpu:1

cd $HOME/dgm-eval
export PATH=$HOME/miniconda3/bin:$PATH
source activate dgm-eval

echo 'Running script'

REPS_TRAIN_PATH="/shared/sets/datasets/CIFAR10-dgm_eval_reps/dinov2/train"
REPS_TEST_PATH="/shared/sets/datasets/CIFAR10-dgm_eval_reps/dinov2/test"

MODELS=("StyleGAN-XL" "PFGMPP" "MHGAN" "StyleGAN2-ada" "BigGAN-Deep")

for model in "${MODELS[@]}"; do
    REAL_GEN_PATH="/shared/sets/datasets/CIFAR10-dgm_eval/CIFAR10-$model/"
    
    for k in {1..9}; do
        OUTPUT_DIR="$HOME/dgm-eval/all_classes_new_formula/$model/k$k"
        mkdir -p "$OUTPUT_DIR"
        echo "Processing folder: $REAL_GEN_PATH with k=$k"
        
        for seed in {1..5}; do
            python -m dgm_eval "$REPS_TRAIN_PATH" "$REAL_GEN_PATH" --test_path "$REPS_TEST_PATH" --output_dir "$OUTPUT_DIR/run_$seed" --model dinov2 --metrics cmmd --device cuda --batch_size 256 --nsample 10000 --no-load --fig_6 --k $k --seed $seed && 
            echo "Completed run_$seed for k=$k in model $model"
        done
    done
done

echo 'Task completed'
