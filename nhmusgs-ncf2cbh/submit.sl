#!/bin/bash
#SBATCH -N 1
#SBATCH -A wbeep
#SBATCH -t 01:00:00
#SBATCH -o ncf2cbh.%j.out
#SBATCH --image=nhmusgs/ncf2cbh:1.1

srun -n 1 shifter --volume=$SOURCE:/nhm /opt/conda/bin/python -u \
     $NHM_SOURCE_DIR/onhm-runners/ncf2cbh/ncf2cbh.py $CBH_IDIR
