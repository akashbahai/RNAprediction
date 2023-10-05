#!/bin/bash
## Set job parameters

## Load the Application
eval `/opt/cray/pe/modules/3.2.11.6/bin/modulecmd bash $*`
module load anaconda3/2022.10
source /home/project/12003580/DeepFoldRNA/conda_local/conda/etc/profile.d/conda.sh
conda activate deepfoldrna

df_dir="/home/project/12003580/DeepFoldRNA"
work_dir=$work
target=$target_rna

python $df_dir/runDeepFoldRNA.py --input_dir $work_dir/$target/df 



