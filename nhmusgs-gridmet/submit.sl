#!/bin/bash
#SBATCH -N 1
#SBATCH -A wbeep
#SBATCH -t 1-0:00
#SBATCH -o gridmet.%j.out
#SBATCH --image=nhmusgs/gridmet:latest

srun -n 1 shifter /bin/bash -c /usr/local/bin/gridmet
