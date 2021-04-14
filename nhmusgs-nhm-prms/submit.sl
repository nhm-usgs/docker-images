#! /bin/bash
#SBATCH -N 1
#SBATCH -A wbeep
#SBATCH -t 01:00:00
#SBATCH -o nhm-prms.%j.out
#SBATCH --image=nhmusgs/nhm-prms:1.1

srun -n 1 -t 0 shifter \
     --volume=/caldera/projects/usgs/water/impd/nhm:/nhm \
     /bin/bash -c /usr/local/bin/prms
