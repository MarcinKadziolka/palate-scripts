#!/bin/bash
#SBATCH --job-name=install_packages
#SBATCH --partition=cpu
#SBATCH --mem-per-cpu=5G
cd $HOME/palate
export PATH=$HOME/miniconda3/bin:$PATH

if [[ "$1" == "" ]] ; then
    echo "Choose option:"
    echo "1. pip install -r requirements"
    echo "2. conda env create -f environment.yml"
    echo "3. conda env update --file environment.yml --prune"
    echo "4. conda install <package>"
    echo "5. conda clean --packages"
    echo "6. conda env list"
    echo "7. conda list"
    echo "9. conda remove -n palate --all -y"
    exit 0
fi

if [[ "$1" == "1" ]] ; then
    echo "1. pip install -r requirements"
    source activate palate
    pip install -r requirements.txt 
elif [[ "$1" == "2" ]] ; then
    echo "2. conda env create -f environment.yml"
    source activate base
    conda env create -f environment.yml
elif [[ "$1" == "3" ]] ; then
    echo "3. conda env update --file environment.yml --prune"
    conda env update --file environment.yml --prune
elif [[ "$1" == "4" ]] ; then
    echo "4. conda install <package>"
    source activate palate
    conda install $2
elif [[ "$1" == "5" ]] ; then
    echo "5. conda clean --packages"
    source activate palate
    conda clean --packages
elif [[ "$1" == "6" ]] ; then
    echo "6. conda env list"
    source activate base
    conda env list
elif [[ "$1" == "7" ]] ; then
    echo "7. conda list"
    source activate palate
    conda list
elif [[ "$1" == "9" ]] ; then
    echo "9. conda remove -n palate --all -y"
    source activate base
    conda remove -n palate --all -y
else
    echo "Option doesn't exist: " $1
fi


echo "sbatch finished"
