#!/bin/bash
#SBATCH --job-name=install_packages
#SBATCH --partition=cpu
#SBATCH --mem-per-cpu=1G
cd $HOME/
export PATH=$HOME/miniconda3/bin:$PATH
source activate
conda env list
echo "done"
