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
    echo $(pwd)
    jobname="rf_$folder"
    output="$directory/$folder/rf/rf.out.txt"
    echo $output
    error="$directory/$folder/rf/rf.err.txt"

    jobfile="$directory/$folder/job_$folder.sh"

    touch "$jobfile"


    echo "#!/bin/bash" | tee "$jobfile"
    echo "bash $jobfile $directory $folder" | tee "$jobfile"
    chmod +rwx "$directory/$folder/job_$folder.sh"
    qsub -P 12003329 -N $jobname -q normal -l select=1:ncpus=128:mpiprocs=128:mem=500G -l walltime=24:00:00 -o $output -e $error $directory/$folder/job_$folder.sh
done

