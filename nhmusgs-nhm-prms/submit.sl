#!/bin/bash
#SBATCH -N 1
#SBATCH -A wbeep
#SBATCH --image=nhmusgs/nhm-prms:latest

srun -n 1 -t 0 shifter --volume=/caldera/projects/usgs/water/impd/nhm:$NHM_DATA_DIR /usr/local/bin/prms
