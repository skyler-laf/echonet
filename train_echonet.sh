#!/bin/bash
#SBATCH --job-name=echonet_full
#SBATCH --partition=gpu
#SBATCH --gres=gpu:1
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --output=/mnt/cv_data/users/skylerlafisca/logs/%x-%j.out
#SBATCH --error=/mnt/cv_data/users/skylerlafisca/logs/%x-%j.err

set -euo pipefail

PROJECT_DIR="$HOME/projects/echonet"
DATA_DIR="$HOME/datasets/EchoNet-Dynamic"
OUTPUT_DIR="$PROJECT_DIR/output/full_training"

# Activate the existing Conda environment (no installs or updates)
source /mnt/cv_data/software/miniconda3/etc/profile.d/conda.sh
conda activate echonet-gpu

cd "$PROJECT_DIR"
mkdir -p "$OUTPUT_DIR"

echo "Job ID:     ${SLURM_JOB_ID:-n/a}"
echo "Node:       $(hostname)"
echo "Start:      $(date)"
echo "Python:     $(which python)"
echo "Data dir:   $DATA_DIR"
echo "Output dir: $OUTPUT_DIR"
nvidia-smi || true

echonet video \
    --data_dir "$DATA_DIR" \
    --output "$OUTPUT_DIR" \
    --num_epochs 45 \
    --batch_size 4 \
    --num_workers 2 \
    --run_test

echo "End:        $(date)"
