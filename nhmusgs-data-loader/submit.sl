#! /bin/bash
#SBATCH -N 1
#SBATCH -A wbeep
#SBATCH -t 01:00:00
#SBATCH -o data-loader.%j.out
#SBATCH --image=nhmusgs/data-loader:1.1
#SBATCH --export=ALL

srun -n 1 shifter --volume=/caldera/projects/usgs/water/impd/nhm:/nhm \
     /bin/bash -c /usr/local/bin/data-loader
