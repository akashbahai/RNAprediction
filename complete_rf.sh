#!/bin/bash

# Assuming the file name is file_list.txt
file=$1

# Check if the file exists
if [ ! -f "$file" ]; then
    echo "File $file not found!"
    exit 1
fi

directory="/home/project/12003580/new_targets"
# Loop through each line in the file and echo it using for loop
for line in $(cat "$file"); do
    echo "$line"
    jobname="rf_$line"
    output="$directory/$line/rf/rf.out.txt"
    error="$directory/$line/rf/rf.err.txt"

    echo "submitting RosettaFold job"
    qsub -P 12003580 -N $jobname -q normal -l select=1:ncpus=16:mpiprocs=16:mem=300G:ngpus=1 -l walltime=24:00:00 -o $output -e $error -v work="$directory",target_rna="$line" /home/project/12003580/run_rf.sh
    echo "RosettaFold job submitted"
done



