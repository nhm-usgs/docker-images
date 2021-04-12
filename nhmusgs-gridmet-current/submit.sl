#! /bin/bash
#SBATCH -N 1
#SBATCH -A wbeep
#SBATCH -t 01:00:00
#SBATCH -o gridmet-current.%j.out
#SBATCH --image=nhmusgs/gridmet-current:1.0

srun -n 1 shifter \
     /bin/bash -c /usr/local/bin/gridmet-current
