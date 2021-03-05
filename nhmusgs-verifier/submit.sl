#!/bin/bash
#SBATCH -N 1
#SBATCH -A wbeep
#SBATCH -t 1-0:00
#SBATCH -o %j.verifier.out
#SBATCH --image=nhmusgs/verifier:1.0

srun -n 1 shifter --volume=$SOURCE:/nhm /opt/conda/bin/python -u \
     $NHM_SOURCE_DIR/onhm-verify-eval/src/prms_verifier.py \
     /nhm/NHM-PRMS_CONUS_GF_1_1/

echo "verifier exit status was $?"
