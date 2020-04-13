#!/bin/bash
#SBATCH -N 1
#SBATCH -A wbeep
#SBATCH -t 1-0:00
#SBATCH -o ofp.%j.out
#SBATCH --image=nhmusgs/ofp:latest

srun -n 1 shifter --volume=/caldera/projects/usgs/water/impd/$USER:/nhm /bin/bash -c /usr/local/bin/ofp
echo "ofp exit status was $?"
