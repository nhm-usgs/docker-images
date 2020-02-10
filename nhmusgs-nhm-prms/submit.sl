#!/bin/bash
#SBATCH -N 1
#SBATCH -A wbeep
#SBATCH -t 1-0:00
#SBATCH -o nhm-prms.%j.out
#SBATCH --image=nhmusgs/nhm-prms:latest

srun -n 1 -t 0 shifter --volume=/caldera/projects/usgs/water/impd/$USER:$NHM_DATA_DIR /usr/local/bin/prms
