#!/bin/bash
#SBATCH -N 1
#SBATCH -A wbeep
#SBATCH --image=nhmusgs/gridmet:latest

srun -n 1 shifter /opt/conda/bin/python -u onhm-fetcher-parser/pkg/Gridmet_current.py
