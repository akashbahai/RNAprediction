#!/bin/bash

# Specify the directory path
directory="/home/project/12003329/casp15"
current_dir=$(pwd)

# Use find command to list folders


# Loop through the folders and print their names
echo "Starting predictions:"
for folder in $(cat "$directory/targetlist.txt"); do
    echo "Processing $folder"
    
    cd "$directory/$folder"
    echo "--------------------------------------------------------------------------------"
    echo "Making RosettaFold prediction for $folder"
    if [[ ! -d "rf" ]]; then
        # Directory does not exist, create it
        mkdir -p "rf"
        echo "Directory created: rf"
    else
        echo "Directory already exists: rf"
    fi
    
    cd $current_dir
    # echo $(pwd)
    jobname="rf_$folder"
    output="$directory/$folder/rf/rf.out.txt"
    error="$directory/$folder/rf/rf.err.txt"

    echo "submitting RosettaFold job"
    qsub -P 12003329 -N $jobname -q normal -l select=1:ncpus=128:mpiprocs=128:mem=300G -l walltime=24:00:00 -o $output -e $error -v work="$directory",target_rna="$folder" /home/project/12003329/run_rf.sh
    echo "RosettaFold job submitted"

    cd "$directory/$folder"
    echo " "
    echo "--------------------------------------------------------------------------------"
    echo "Making DeepFoldRNA prediction for $folder"
    if [[ ! -d "df" ]]; then
        # Directory does not exist, create it
        mkdir -p "df"
        echo "Directory created: df"
    else
        echo "Directory already exists: df"
    fi

    cp $folder.fa $directory/$folder/df/seq.fasta
    
    cd $current_dir
    # echo $(pwd)
    jobname="df_$folder"
    output="$directory/$folder/df/df.out.txt"
    error="$directory/$folder/df/df.err.txt"

    echo "submitting DeepFoldRNA job"
    qsub -P 12003329 -N $jobname -q normal -l select=1:ncpus=64:mpiprocs=64:mem=300G -l walltime=24:00:00 -o $output -e $error -v work="$directory",target_rna="$folder" /home/project/12003329/run_df.sh
    echo "DeepFoldRNA job submitted"

    cd "$directory/$folder"
    echo " "
    echo "--------------------------------------------------------------------------------"
    echo "Making RhoFold prediction for $folder"
    if [[ ! -d "rhofold" ]]; then
        # Directory does not exist, create it
        mkdir -p "rhofold"
        echo "Directory created: rhofold"
    else
        echo "Directory already exists: rhofold"
    fi
    
    cd $current_dir
    # echo $(pwd)
    jobname="rhofold_$folder"
    output="$directory/$folder/rhofold/rhofold.out.txt"
    error="$directory/$folder/rhofold/rhofold.err.txt"

    echo "submitting RhoFold job"
    qsub -P 12003329 -N $jobname -q normal -l select=1:ncpus=64:mpiprocs=64:mem=300G -l walltime=24:00:00 -o $output -e $error -v work="$directory",target_rna="$folder" /home/project/12003329/run_rhofold.sh
    echo "RhoFold job submitted"


    cd "$directory/$folder"
    echo " "
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
    qsub -P 12003329 -N $jobname -q normal -l select=1:ncpus=64:mpiprocs=64:mem=300G -l walltime=24:00:00 -o $output -e $error -v work="$directory",target_rna="$folder" /home/project/12003329/run_drfold.sh
    echo "DRFold job submitted"
    echo " "
    echo "Processing $folder done!"
    echo "--------------------------------------------------------------------------------"
    echo "--------------------------------------------------------------------------------"

done

