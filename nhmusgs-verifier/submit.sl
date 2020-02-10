#!/bin/bash
#SBATCH -N 1
#SBATCH -A wbeep
#SBATCH -t 1-0:00
#SBATCH -o verifier.%j.out
#SBATCH --image=nhmusgs/verifier:latest

srun -n 1 shifter --volume=/caldera/projects/usgs/water/impd/$USER:$NHM_DATA_DIR /bin/bash -c /usr/local/bin/verifier
