#!/bin/bash
#SBATCH -N 1
#SBATCH -A wbeep
#SBATCH -t 1-0:00
#SBATCH -o ofp.%j.out
#SBATCH --image=nhmusgs/ofp:latest

srun -n 1 shifter --volume=/caldera/projects/usgs/water/impd/$USER:$NHM_DATA_DIR /usr/local/bin/ofp
