#!/bin/bash
#SBATCH -N 1
#SBATCH -A wbeep
#SBATCH -t 1-0:00
#SBATCH -o ncf2cbh.%j.out
#SBATCH --image=nhmusgs/ncf2cbh:latest

srun -n 1 shifter --volume=$SOURCE:/nhm /opt/conda/bin/python -u $NHM_SOURCE_DIR/onhm-runners/ncf2cbh/ncf2cbh.py /nhm/NHM-PRMS_CONUS/input/
echo "ncf2cbh exit status was $?"
