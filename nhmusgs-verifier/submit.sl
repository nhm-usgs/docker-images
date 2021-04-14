#!/bin/bash
#SBATCH -N 1
#SBATCH -A wbeep
#SBATCH -t 01:00:00
#SBATCH -o verifier.%j.out
#SBATCH --image=nhmusgs/verifier:1.1

srun -n 1 shifter --volume=/caldera/projects/usgs/water/impd/nhm:/nhm \
   /bin/bash -c /usr/local/bin/verifier
