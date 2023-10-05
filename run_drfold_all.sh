#!/bin/bash

# Specify the directory path
directory="/home/project/12003580/ss"
current_dir=$(pwd)

# Use find command to list folders


# Loop through the folders and print their names
echo "Starting predictions:"
for folder in $(cat "$directory/newtargetlist.txt"); do
    echo "Processing $folder"
    
    cd "$directory/$folder"
    echo "--------------------------------------------------------------------------------"
    
    echo "--------------------------------------------------------------------------------"
    echo "Making DRFold prediction for $folder"
    if [[ ! -d "drfold" ]]; then
        # Directory does not exist, create it
        mkdir -p "drfold"
        echo "Directory created: drfold"
    else
        echo "Directory already exists: drfold"
    fi
    
    cd $current_dir
    # echo $(pwd)
    jobname="drfold_$folder"
    output="$directory/$folder/drfold/drfold.out.txt"
    error="$directory/$folder/drfold/drfold.err.txt"

    echo "submitting DRFold job"
    qsub -P 12003580 -N $jobname -q normal -l select=1:ncpus=64:mpiprocs=64:mem=400G -l walltime=120:00:00 -o $output -e $error -v work="$directory",target_rna="$folder" /home/project/12003580/run_drfold_ss.sh
    echo "DRFold job submitted"
    echo " "
    echo "Processing $folder done!"
    echo "--------------------------------------------------------------------------------"
    echo "--------------------------------------------------------------------------------"

done

