#!/bin/bash
#SBATCH -N 1
#SBATCH -A wbeep
#SBATCH --image=nhmusgs/ncf2cbh:latest

srun -n 1 shifter --volume=/caldera/projects/usgs/water/impd/nhm:$NHM_DATA_DIR /opt/conda/bin/python -u /usr/local/src/onhm-runners/ncf2cbh/ncf2cbh.py
