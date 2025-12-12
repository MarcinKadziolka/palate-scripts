#!/bin/bash
#SBATCH --job-name=test_paths
#SBATCH --partition=cpu
#SBATCH --mem-per-cpu=1G
cd $HOME/
export PATH=$HOME/miniconda3/bin:$PATH
source activate dgm-eval
echo "starting the cpu run"
python3 -m dgm_eval.get_representations --folder_path /shared/sets/datasets/CIFAR10-dgm_eval --model inception --device cpu
echo "done"
