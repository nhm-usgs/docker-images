#!/bin/bash
#SBATCH -N 1
#SBATCH -A wbeep
#SBATCH -t 1-0:00
#SBATCH -o %j.cbhfiller.out
#SBATCH --image=nhmusgs/cbhfiller:1.0

srun -n 1 -t 0 shifter \
     --volume=/caldera/projects/usgs/water/impd/nhm:/nhm \
     /bin/bash -c /usr/local/bin/cbhfiller

echo "cbhfiller exit status was $?"
