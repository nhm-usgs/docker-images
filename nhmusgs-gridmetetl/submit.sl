#!/bin/bash
#SBATCH -N 1
#SBATCH -A wbeep
#SBATCH -t 1-0:00
#SBATCH -o gridmetetl.%j.out
#SBATCH --image=nhmusgs/gridmetetl:1.0

srun -n 1 shifter --volume=/caldera/projects/usgs/water/impd/nhm:/nhm \
     /bin/bash -c /usr/local/bin/gridmetetl
