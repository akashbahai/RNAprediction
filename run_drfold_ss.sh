	#!/bin/bash
## Set job parameters

## Load the Application
#eval `/opt/cray/pe/modules/3.2.11.6/bin/modulecmd bash $*`
module load anaconda3/2022.10
conda activate drfold

drfold_dir="/home/project/12003580/DRfold"
work_dir=$work
target=$target_rna
ss="$target.ss.txt"


bash $drfold_dir/DRfold_ss.sh $work_dir/$target/$target.fasta $work_dir/$target/drfold $work_dir/$target/$ss



