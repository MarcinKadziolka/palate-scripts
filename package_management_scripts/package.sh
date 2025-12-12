#!/bin/bash
#SBATCH --job-name=install_packages
#SBATCH --partition=cpu
#SBATCH --mem-per-cpu=5G
# USAGE
# sbatch package.sh <package-name>
cd $HOME/palate
export PATH=$HOME/miniconda3/bin:$PATH
source activate palate
echo "Installing package" $1
#pip install -r requirements.txt
conda install $1
echo "sbatch finished"

