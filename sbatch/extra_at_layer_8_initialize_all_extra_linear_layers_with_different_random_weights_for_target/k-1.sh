#!/bin/bash
#SBATCH --job-name=k-1_extra_at_layer_8_initialize_all_extra_linear_layers_with_different_random_weights_for_target
#SBATCH -o sbatch_logs/stdout/k-1_extra_at_layer_8_initialize_all_extra_linear_layers_with_different_random_weights_for_target_%j.txt
#SBATCH -e sbatch_logs/stderr/k-1_extra_at_layer_8_initialize_all_extra_linear_layers_with_different_random_weights_for_target_%j.err
#SBATCH --ntasks=1
#SBATCH --partition=2080ti-long
#SBATCH --gres=gpu:1
#SBATCH --mem=24GB
#SBATCH --cpus-per-task=2

eval "$(conda shell.bash hook)"
conda activate qm

EXPERIMENT_ID_PREFIX=k-1_extra_at_layer_8_initialize_all_extra_linear_layers_with_different_random_weights_for_target
EXPERIMENT_DATE=`date +"%m-%d"`

python train.py --save_dir save_${EXPERIMENT_ID_PREFIX}_${EXPERIMENT_DATE} \
                --train_file 0819_shard_0_1/data-train.p --train_size 670470 \
                --val_file 0819_shard_0_1/data-val.p --val_size 168015 \
                --model_behavior 'quartermaster' --num_facets 1 \
                --add_extra_facet_layers --add_extra_facet_layers_initialize_with_identical_random_weights \
                --add_extra_facet_layers_initialize_differently_for_target \
                --add_extra_facet_layers_after 7 \
                --add_extra_facet_nonlinearity \
                --loss_reduction_multifacet 'min' \
                --gpus 1 --num_workers 0 --fp16 \
                --batch_size 2 --grad_accum 16  --num_epochs 2 \
                --wandb
