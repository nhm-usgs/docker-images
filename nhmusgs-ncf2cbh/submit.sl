#!/bin/bash
#SBATCH -N 1
#SBATCH -A wbeep
#SBATCH -t 1-0:00
#SBATCH -o %j.ncf2cbh.out
#SBATCH --image=nhmusgs/ncf2cbh:latest

srun -n 1 shifter --volume=$SOURCE:/nhm /opt/conda/bin/python -u \
     $NHM_SOURCE_DIR/onhm-runners/ncf2cbh/ncf2cbh.py $CBH_IDIR

echo "ncf2cbh exit status was $?"
