#!/bin/bash
#SBATCH -N 1
#SBATCH -A wbeep
#SBATCH -t 1-0:00
#SBATCH -o out2ncf.%j.out
#SBATCH --image=nhmusgs/out2ncf:latest

srun -n 1 shifter --volume=/caldera/projects/usgs/water/impd/$USER:$NHM_DATA_DIR /opt/conda/bin/python -u /usr/local/src/onhm-runners/out2ncf/prms_outputs2_ncf.py /nhm/NHM-PRMS_CONUS/
