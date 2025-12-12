#!/bin/bash
#SBATCH --job-name=install_packages
#SBATCH --partition=cpu
#SBATCH --mem-per-cpu=5G
cd $HOME/palate
export PATH=$HOME/miniconda3/bin:$PATH
conda remove -n palate --all
echo "sbatch finished"

