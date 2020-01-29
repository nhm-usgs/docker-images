#!/bin/bash
#SBATCH -N 1
#SBATCH -A wbeep
#SBATCH --image=nhmusgs/gridmet:latest

srun -n 1 shifter /bin/bash -c /usr/local/bin/gridmet
