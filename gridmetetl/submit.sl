#!/bin/bash
#SBATCH -N 1
#SBATCH -A wbeep
#SBATCH -t 1-0:00
#SBATCH -o gridmetetl.%j.out
#SBATCH --image=nhmusgs/gridmetetl:latest

srun -n 1 shifter --volume=$SOURCE:/nhm -e START_DATE=$START_DATE -e END_DATE=$END_DATE /bin/bash -c /usr/local/bin/gridmetetl
echo "gridmetetl exit status was $?"
