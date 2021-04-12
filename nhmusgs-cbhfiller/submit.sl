#! /bin/bash
#SBATCH -N 1
#SBATCH -A wbeep
#SBATCH -t 01:00:00
#SBATCH -o cbhfiller.%j.out
#SBATCH --image=nhmusgs/cbhfiller:1.0

# the volume here is specific to denali; it would need to
# be updated to run on another system
srun -n 1 -t 0 shifter \
     --volume=/caldera/projects/usgs/water/impd/nhm:/nhm \
     /bin/bash -c /usr/local/bin/cbhfiller
