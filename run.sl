#!/bin/bash
#SBATCH -N 1
#SBATCH -A wbeep
#SBATCH -t 1-0:00
#SBATCH -o run.%j.out
#
# U.S. Geological Survey
#
# File - run.sl
#
# Purpose - Simulate NHM run on Shifter, as might be done by Jenkins.
#
# Authors - Ivan Suftin, Richard McDonald, Andrew Halper
#

# Docker Compose (which also references nhm.env) can't cope with .env
# files containing the shell's "export ..." syntax, so this is
# necessary to work around that.
set -a

# environment variables file
. ./nhm.env

# encapsulate some container running boiler-plate
run () {
    svc=$1
    shift

    echo ""
    echo "Running $svc..."
    
    # the "yq" command below is here to map service names in
    # docker-compose.yml to sub-directory names; unfortunately they
    # don't have the same names

    # if this is the first job...
    if [ -z "$previous_jobid" ]
    then
	# ...start job with no dependency
      jobid=$(sbatch --parsable \
	      "`yq r docker-compose.yml services.$svc.build.context`/submit.sl")
    else
    # ...start job with the requirement that the previous job
    # completed successfully (exit code 0)
      jobid=$(sbatch --parsable --dependency=afterok:$previous_jobid \
	      "`yq r docker-compose.yml services.$svc.build.context`/submit.sl")
    fi

    # set current jobid to previous_jobid to be used as a dependency
    # by the next job
    previous_jobid=$jobid
} # run

echo "Checking if HRU data is downloaded..."
if [ ! -d $HRU_DATA_PREFIX/nhm_hru_data ]; then
    echo "HRU data needs to be downloaded"
    wget --waitretry=3 --retry-connrefused "${HRU_SOURCE}" \
	-O "data/${HRU_DATA_PKG}"
fi

echo "Checking if PRMS data is downloaded..."
if [ ! -d $PRMS_DATA_PREFIX/NHM-PRMS_CONUS ]; then
    echo "PRMS data needs to be downloaded"
    wget --waitretry=3 --retry-connrefused "${PRMS_SOURCE}" \
	-O "data/${PRMS_DATA_PKG}"
fi

COMPOSE_FILES="-f docker-compose.yml -f docker-compose-testing.yml"

# check for Shifter module
if ! module list |& grep ' shifter/' > /dev/null 2>&1 ; then
    echo "Loading Shifter module..."
    module load shifter
fi

# call run() function above
run data_loader

# start date is the base name of the last restart file
RESTART_DATE=`ls $SOURCE/NHM-PRMS_CONUS/restart/*.restart | \
	      sed 's/^.*\///;s/\.restart$//' | \
	      sort | tail -1`
# end date is yesterday
yesterday=`date --date yesterday --rfc-3339='date'`

# if END_DATE is not set already
if [ "$END_DATE" = "" ]; then
    END_DATE=$yesterday
fi

# if START_DATE is not set already
if [ "$START_DATE" = "" ]; then
    START_DATE=`date --date "$RESTART_DATE +1 day" --rfc-3339='date'`
fi

if [ "$SAVE_RESTART_DATE" = "" ]; then
    SAVE_RESTART_DATE=`date --date "$yesterday -59 days" --rfc-3339='date'`
fi

# if we want to run the Gridmet service...
if [ "$GRIDMET_DISABLE" != true ]; then
  run gridmet
fi

run ofp
run ncf2cbh

# PRMS

# start time is $START_DATE in PRMS start_date datetime format
START_TIME=`date --date $START_DATE +%Y,%m,%d,00,00,00`
# end time is start date + 1 day in PRMS end_date datetime format
END_TIME=`date --date $END_DATE +%Y,%m,%d,00,00,00`
SAVE_VARS_TO_FILE=0

run nhm-prms
run out2ncf
run verifier

# run PRMS service in restart mode

# end time is start date + 1 day in PRMS end_date datetime format
END_TIME=`date --date "$yesterday -59 days" +%Y,%m,%d,00,00,00`
SAVE_VARS_TO_FILE=1
VAR_SAVE_FILE="-set var_save_file /nhm/NHM-PRMS_CONUS/restart/$SAVE_RESTART_DATE.restart"

run nhm-prms

echo "Slurm jobs scheduled."
