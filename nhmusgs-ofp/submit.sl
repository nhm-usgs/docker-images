#!/bin/bash
#SBATCH -N 1
#SBATCH -A wbeep
#SBATCH --image=scanon/mpi:test

srun -n 64 shifter /app/hello
