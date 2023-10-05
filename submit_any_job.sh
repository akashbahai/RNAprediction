#!/bin/bash
# echo "test"
# Function to display usage of the script
usage() {
    echo "Usage: $0 <target_directory_path> <method_name> <prediction_mode>"
    echo "Methods: rf, df, drfold, rhofold, rhofold_msa"
    echo "Prediction Modes: cpu, gpu, cpu_large, cpu_long"
    exit 1
}

# Check the number of arguments
if [ "$#" -ne 3 ]; then
    usage
fi

# Store the command-line arguments in variables
working_dir=$(readlink -f "$(dirname "$1")")
target=$(basename "$1")
method=$2
mode=$3

# Check if the method is valid
case "$method" in
    rf|df|drfold|rhofold|rhofold_msa)
        # Valid method
        ;;
    *)
        echo "Error: Invalid method! Supported methods are: rf, df, drfold, rhofold, rhofold_msa"
        usage
        ;;
esac

# Check if the mode is valid
case "$mode" in
    cpu|gpu|cpu_large|cpu_long)
        # Valid mode
        ;;
    *)
        echo "Error: Invalid prediction mode! Supported modes are: cpu, gpu, cpu_large, cpu_long"
        usage
        ;;
esac

# Check if the target directory exists
if [ ! -d "$working_dir/$target" ]; then
    echo "Error: Target directory does not exist!"
    usage
fi

# Check if the targetname.fasta file exists
if [ ! -f "$working_dir/$target/$target.fasta" ]; then
    echo "Error: $target.fasta file doesn't exist in the target directory!"
    usage
fi

# Check if the method directory exists or create it
method_dir="$working_dir/$target/$method"
if [ ! -d "$method_dir" ]; then
    mkdir -p "$method_dir"
fi

if [[ $method == "df" || $method == "rf" || $method == "drfold" ]]; then
    method_to_run=$method
elif [[ $method == "rhofold" || $method == "rhofold_msa" ]]; then
    method_to_run="rhofold"
else
    echo "Invalid method value"
    exit 1
fi



jobname="${target}_${method}"
output="$working_dir/$target/${method_to_run}/${method_to_run}_out.txt"
error="$working_dir/$target/${method_to_run}/${method_to_run}_err.txt"

# Check if the mode is valid
if [ "$mode" == "cpu" ]; then
    # CPU mode
    resource="select=1:ncpus=64:mpiprocs=64:mem=300G"
    walltime="24:00:00"
elif [ "$mode" == "gpu" ]; then
    # GPU mode
    resource="select=1:ncpus=64:mpiprocs=64:mem=300G:ngpus=4"
    walltime="24:00:00"
elif [ "$mode" == "cpu_large" ]; then
    # CPU large mode
    resource="select=1:ncpus=128:mpiprocs=128:mem=2000G"
    walltime="24:00:00"
elif [ "$mode" == "cpu_long" ]; then
    # CPU long mode
    resource="select=1:ncpus=128:mpiprocs=128:mem=440G"
    walltime="120:00:00"
else
    echo "Error: Invalid mode! Supported modes are: cpu, gpu, cpu_large, cpu_long"
    usage
fi
#echo "working"
# If the method is df, copy targetname.fasta as seq.fasta inside the df directory
if [ "$method" == "df" ]; then
    #echo "stuck"
    cp -n "$working_dir/${target}/${target}.fasta" "$working_dir/$target/${method}/seq.fasta"
    #echo "not reaching here"
fi


echo "The script to run is: ${method_to_run}"

script="/home/project/12003580/run_${method_to_run}.sh"
echo "workdir is $working_dir, target is $target, method is $method, mode is $mode"

qsub -P 12003580 -N $jobname -q normal -l $resource -l walltime=$walltime -o $output -e $error -v work="$working_dir",target_rna="$target",mode="$mode",method="$method" $script