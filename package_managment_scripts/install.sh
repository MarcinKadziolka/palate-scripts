#!/bin/bash
#SBATCH --job-name=install_packages
#SBATCH --partition=cpu
#SBATCH --mem-per-cpu=5G
cd $HOME/
export PATH=$HOME/miniconda3/bin:$PATH
source activate dgm-eval
pip install -r requirements.txt
echo "sbatch finished"

