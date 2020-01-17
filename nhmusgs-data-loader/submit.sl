#!/bin/bash
#SBATCH -N 1
#SBATCH -A wbeep
#SBATCH --image=nhmusgs/data-loader:latest
#SBATCH --volume=/tmp/nhm:/nhm

srun -n 1 shifter /usr/local/bin/nhm
