#!/bin/bash
#SBATCH -N 1
#SBATCH -A wbeep
#SBATCH -t 1-0:00
#SBATCH -o verifier.%j.out
#SBATCH --image=nhmusgs/verifier:latest

srun -n 1 shifter --volume=/caldera/projects/usgs/water/impd/$USER:$NHM_DATA_DIR /opt/conda/bin/python -u /usr/local/src/onhm-verify-eval/src/prms_verifier.py /nhm/NHM-PRMS_CONUS/
