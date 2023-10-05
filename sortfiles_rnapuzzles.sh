#!/bin/bash

script_dir=$(readlink -f "$(dirname "$0")")
log_file="/home/project/12003580/analysis/rnapuzzles/copy_pdb_log.txt"

# Check if the log file exists and is not empty
if [ -s "$log_file" ]; then
    # If it exists and is not empty, create a new empty file
    > "$log_file"
fi

# Read the list of target directories from targetlist.txt
while IFS= read -r target_dir
do
    cd /home/project/12003580/rnapuzzles
    # Check if the target directory exists
    if [ -d "$target_dir" ]; then
        # Create a new location based on the target directory name
        new_location="/home/project/12003580/analysis/rnapuzzles/$target_dir"

        # Create the new location directory if it doesn't exist
        mkdir -p "$new_location"

        
        # Copy specific PDB files from the subdirectories to the new location
        if [ -s "/home/project/12003580/rnapuzzles/$target_dir/df/model_1/final_models/refined_model.pdb" ]; then
            cp -n "/home/project/12003580/rnapuzzles/$target_dir/df/model_1/final_models/refined_model.pdb" "$new_location/${target_dir}_df.pdb" 2>/dev/null || echo "Refined model PDB file found in '$target_dir/df'." >> "$log_file"
        else
            echo "Error: Refined model PDB file not found or empty in '$target_dir/df'." >> "$log_file"
        fi

        if [ -s "/home/project/12003580/rnapuzzles/$target_dir/rf/models/model_00.pdb" ]; then
            cp -n "/home/project/12003580/rnapuzzles/$target_dir/rf/models/model_00.pdb" "$new_location/${target_dir}_rf.pdb" 2>/dev/null || echo "Model 00 PDB file found in '$target_dir/rf'." >> "$log_file"
        else
            echo "Error: Model 00 PDB file not found or empty in '$target_dir/rf'." >> "$log_file"
        fi

        if [ -s "/home/project/12003580/rnapuzzles/$target_dir/drfold/DPR.pdb" ]; then
            cp -n "/home/project/12003580/rnapuzzles/$target_dir/drfold/DPR.pdb" "$new_location/${target_dir}_drfold.pdb" 2>/dev/null || echo "DPR PDB file found in '$target_dir/rfold'." >> "$log_file"
        else
            echo "Error: DPR PDB file not found or empty in '$target_dir/rfold'." >> "$log_file"
        fi

        if [ -s "/home/project/12003580/rnapuzzles/$target_dir/rhofold/relaxed_100_model.pdb" ]; then
            cp -n "/home/project/12003580/rnapuzzles/$target_dir/rhofold/relaxed_100_model.pdb" "$new_location/${target_dir}_rhofold.pdb" 2>/dev/null || echo "Relaxed 100 model PDB file found in '$target_dir/rhofold'." >> "$log_file"
        else
            echo "Error: Relaxed 100 model PDB file not found or empty in '$target_dir/rhofold'." >> "$log_file"
        fi
    else
        echo "Error: Target directory '$target_dir' does not exist." >> "$log_file"
    fi
done < "$1"
