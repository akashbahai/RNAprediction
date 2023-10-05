#!/bin/bash
## Set job parameters

## Load the Application
eval `/opt/cray/pe/modules/3.2.11.6/bin/modulecmd bash $*`
module load anaconda3/2022.10
conda activate rhofold

rhofold_dir="/home/project/12003580/RhoFold"
work_dir=$work
target=$target_rna
mode=$mode
method=$method

if [[ "$mode" == "cpu" || "$mode" == "cpu_large" || "$mode" == "cpu_long" ]]; then
    device="cpu"
elif [[ "$mode" == "gpu" ]]; then
    device="cuda:0"
else
    echo "Wrong device selected. Exiting!"
    exit 1
fi

if [[ "$method" == "rhofold" ]]; then
    python $rhofold_dir/inference.py --input_fas $work_dir/$target/$target.fasta --output_dir $work_dir/$target/rhofold/ --device $device --ckpt $rhofold_dir/pretrained/rhofold_pretrained.pt --relax_steps 100 --database_dpath /home/project/12003580/RoseTTAFold2NA/RNA --binary_dpath $rhofold_dir/rhofold/data/bin
elif [[ "$method" == "rhofold_msa" ]]; then
    python $rhofold_dir/inference.py --input_fas $work_dir/$target/$target.fasta --input_a3m $work_dir/$target/rhofold/seq.a3m --output_dir $work_dir/$target/rhofold/ --device $device --ckpt $rhofold_dir/pretrained/rhofold_pretrained.pt --relax_steps 100 --database_dpath /home/project/12003580/RoseTTAFold2NA/RNA --binary_dpath $rhofold_dir/rhofold/data/bin
else
    echo "Wrong method"
    exit 1
fi







