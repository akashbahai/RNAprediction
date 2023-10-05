#!/bin/bash

script_dir=$(readlink -f "$(dirname "$0")")

file_path="$1"
# Get the complete path of the file
complete_path=$(realpath "$file_path")

# Extract the directory of the file
directory=$(dirname "$complete_path")

target_dataset=$(basename ${directory})



log_file="/home/project/12003580/analysis/msa/copy_msa_${target_dataset}_log.txt"
echo "target dataset:" $directory
echo "logging errors into:" ${log_file}

if [ -f "${log_file}" ]; then
    # File exists, so delete it
    rm "$log_file"
fi
touch ${log_file}

# Read the list of target directories from targetlist.txt
while IFS= read -r target_dir
do
    cd $directory
    #echo $pwd
    # Check if the target directory exists
    if [ -d "$target_dir" ]; then
        # Create a new location based on the target directory name
        new_location="/home/project/12003580/analysis/msa/$target_dir"

        # Create the new location directory if it doesn't exist
        mkdir -p "$new_location"

        # Copy specific PDB files from the subdirectories to the new location
        if [ -s "$directory/$target_dir/df/seq.afa" ]; then
            cp -n "$directory/$target_dir/df/seq.afa" "$new_location/df.afa" 2>/dev/null || echo "MSA file found in '$target_dir/df'." >> "$log_file"
        else
            echo "Error: MSA file not found or empty in '$target_dir/df'." >> "$log_file"
        fi

        if [ -s "$directory/$target_dir/rf/${target_dir}.afa" ]; then
            cp -n "$directory/$target_dir/rf/${target_dir}.afa" "$new_location/rf.afa" 2>/dev/null || echo "MSA file found in '$target_dir/rf'." >> "$log_file"
        else
            echo "Error: MSA file not found or empty in '$target_dir/rf'." >> "$log_file"
        fi

        if [ -s "$directory/$target_dir/rhofold/seq.a3m" ]; then
            cp -n "$directory/$target_dir/rhofold/seq.a3m" "$new_location/rhofold.a3m" 2>/dev/null || echo "MSA file found in '$target_dir/rhofold'." >> "$log_file"
        else
            echo "MSA file not found or empty in '$target_dir/rhofold'." >> "$log_file"
        fi
    else
        echo "Error: Target directory '$target_dir' does not exist." >> "$log_file"
    fi
done < "$1"
