#!/bin/bash
#SBATCH -N 1
#SBATCH -A wbeep
#SBATCH --image=nhmusgs/ofp:latest

srun -n 1 shifter --volume=/caldera/projects/usgs/water/impd/nhm:$NHM_DATA_DIR /usr/local/bin/ofp
