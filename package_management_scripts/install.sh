#!/bin/bash
#SBATCH --job-name=install_packages
#SBATCH --partition=cpu
#SBATCH --mem-per-cpu=5G
cd $HOME/palate
export PATH=$HOME/miniconda3/bin:$PATH
source activate palate
#pip install -r requirements.txt
#conda env update --file environment.yml  --prune
conda install python=3.12
echo "sbatch finished"

