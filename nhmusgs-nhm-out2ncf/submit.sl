#!/bin/bash
#SBATCH -N 1
#SBATCH -A wbeep
#SBATCH -t 1-0:00
#SBATCH -o %j.out2ncf.out
#SBATCH --image=nhmusgs/out2ncf:1.0

srun -n 1 shifter --volume=/caldera/projects/usgs/water/impd/nhm:/nhm \
     /opt/conda/bin/python -u \
     $NHM_SOURCE_DIR/onhm-runners/out2ncf/prms_outputs2_ncf.py \
     /nhm/NHM-PRMS_CONUS_GF_1_1

echo "out2ncf exit status was $?"
