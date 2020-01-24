#!/bin/bash
#SBATCH -N 1
#SBATCH -A wbeep
#SBATCH --image=nhmusgs/out2ncf:latest

srun -n 1 shifter --volume=/caldera/projects/usgs/water/impd/nhm:/nhm /opt/conda/bin/python -u /usr/local/src/onhm-runners/out2ncf/prms_outputs2_ncf.py
