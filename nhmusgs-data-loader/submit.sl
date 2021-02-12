#!/bin/bash
#SBATCH -N 1
#SBATCH -A wbeep
#SBATCH -t 1-0:00
#SBATCH -o %j.data-loader.out
#SBATCH --image=nhmusgs/data-loader:latest

srun -n 1 shifter /bin/bash -c /usr/local/bin/data-loader
