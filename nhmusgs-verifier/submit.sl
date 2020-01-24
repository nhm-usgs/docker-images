#!/bin/bash
#SBATCH -N 1
#SBATCH -A wbeep
#SBATCH --image=nhmusgs/verifier:latest

srun -n 1 shifter --volume=/caldera/projects/usgs/water/impd/nhm:/nhm /opt/conda/bin/python -u /usr/local/src/onhm-verify-eval/src/prms_verifier.py
