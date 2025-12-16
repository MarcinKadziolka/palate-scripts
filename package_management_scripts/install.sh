#!/bin/bash
#SBATCH --job-name=install_packages
#SBATCH --partition=cpu
#SBATCH --mem-per-cpu=5G
cd $HOME/scripts
export PATH=$HOME/miniconda3/bin:$PATH
if [[ "$1" == "" ]] ; then
    echo "Choose option:"
    echo "1. pip install -r requirements"
    echo "2. conda env create -f continued.yaml"
    echo "3. conda env update --file continued.yaml --prune"
    echo "4. conda install <package>"
    echo "5. conda clean --packages"
    echo "6. conda env list"
    echo "7. conda list"
    echo "9. conda remove -n continued --all -y"
    exit 0
fi

if [[ "$1" == "1" ]] ; then
    echo "1. pip install -r requirements"
    source activate continued
    pip install -r requirements.txt 
elif [[ "$1" == "2" ]] ; then
    echo "2. conda env create -f continued.yaml"
    source activate base
    conda env create -f continued.yaml
elif [[ "$1" == "3" ]] ; then
    echo "3. conda env update --file continued.yaml --prune"
    conda env update --file continued.yaml --prune
elif [[ "$1" == "4" ]] ; then
    echo "4. conda install <package>"
    source activate continued
    conda install $2
elif [[ "$1" == "5" ]] ; then
    echo "5. conda clean --packages"
    source activate continued
    conda clean --packages
elif [[ "$1" == "6" ]] ; then
    echo "6. conda env list"
    source activate base
    conda env list
elif [[ "$1" == "7" ]] ; then
    echo "7. conda list"
    source activate continued
    conda list
elif [[ "$1" == "9" ]] ; then
    echo "9. conda remove -n continued --all -y"
    source activate base
    conda remove -n continued --all -y
else
    echo "Option doesn't exist: " $1
fi


echo "sbatch finished"
