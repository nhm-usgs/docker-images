#!/bin/bash
#SBATCH -N 1
#SBATCH -A wbeep
#SBATCH -t 1-0:00
#SBATCH -o out2ncf.%j.out
#SBATCH --image=nhmusgs/out2ncf:latest

srun -n 1 shifter --volume=$SOURCE:/nhm /opt/conda/bin/python -u $NHM_SOURCE_DIR/onhm-runners/out2ncf/prms_outputs2_ncf.py /nhm/NHM-PRMS_CONUS/
echo "out2ncf exit status was $?"
