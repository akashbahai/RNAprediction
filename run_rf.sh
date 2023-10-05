#!/bin/bash
## Set job parameters

## Load the Application
eval `/opt/cray/pe/modules/3.2.11.6/bin/modulecmd bash $*`
module load anaconda3/2022.10
conda activate RF2NA

rf_dir="/home/project/12003580/RoseTTAFold2NA"
work_dir=$work
target=$target_rna


bash $rf_dir/run_RF2NA.sh $work_dir/$target/rf/ R:$work_dir/$target/$target.fasta



