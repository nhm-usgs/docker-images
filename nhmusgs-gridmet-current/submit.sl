#!/bin/bash
#SBATCH -N 1
#SBATCH -A wbeep
#SBATCH -t 1-0:00
#SBATCH -o gridmet-current.%j.out
#SBATCH --image=nhmusgs/gridmet-current:latest

srun -n 1 shifter /opt/conda/bin/python -u $NHM_SOURCE_DIR/gridmetetl/gridmetetl/Gridmet_current.py
