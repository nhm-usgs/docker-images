#!/bin/bash
#SBATCH -N 1
#SBATCH -A wbeep
#SBATCH -t 1-0:00
#SBATCH -o %j.data-loader.out
#SBATCH --image=nhmusgs/data-loader:1.0
#SBATCH --export=ALL

srun -n 1 shifter /bin/bash -c /usr/local/bin/data-loader
