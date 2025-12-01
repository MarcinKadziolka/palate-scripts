#!/bin/bash
#SBATCH --job-name=get_repr
#SBATCH --qos=normal
#SBATCH --partition=rtx4090
#SBATCH --mem=32G
#SBATCH --gres=gpu:1
cd $HOME/dgm-eval
export PATH=$HOME/miniconda3/bin:$PATH
source activate dgm-eval
echo 'Running get_representations'
python3 -m dgm_eval.get_representations --folder_path /shared/sets/datasets/CIFAR10-dgm_eval --model dinov2
echo 'Done'
