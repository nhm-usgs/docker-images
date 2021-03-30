#!/bin/bash
#SBATCH -N 1
#SBATCH -A wbeep
#SBATCH -o %j.run.out
#
# U.S. Geological Survey
#
# File - run.sl
#
# Purpose - Simulate NHM run on Docker and Shifter, as might be done
#           by Jenkins.
#
# Authors - Ivan Suftin, Richard McDonald, Andrew Halper
#

if [ "$X" = -x ]; then
    set -x			# run in debug mode
fi

# Docker Compose (which also references nhm.env) can't cope with .env
# files containing the shell's "export ..." syntax, so this is
# necessary to work around that.
set -a

# environment variables file
. ./nhm.env

# are we on HPC?
uname -r | grep cray > /dev/null 2>&1
hpc=$?

# encapsulate some container running boiler-plate
run () {
    svc=$1
    shift

    echo ""
    echo "Running $svc..."
    
    # the "yq" command below is here to map service names in
    # docker-compose.yml to sub-directory names; unfortunately they
    # don't have the same names

    # if on HPC ...
    if [ $hpc = 0 ]; then		# ... run on Shifter
      # if this is the first job...
      if [ -z "$previous_jobid" ]; then
	# ...start job with no dependency
	jobid=$(sbatch --parsable --job-name=$svc \
	      "`yq e .services.$svc.build.context docker-compose.yml`/submit.sl")
      else
	# ...start job with the requirement that the previous job
	# completed successfully (exit code 0)
	jobid=$(sbatch --parsable --job-name=$svc \
		       --dependency=afterok:$previous_jobid \
		       --kill-on-invalid-dep=yes \
	      "`yq e .services.$svc.build.context docker-compose.yml`/submit.sl")
	
	# set current jobid to previous_jobid to be used as a dependency
	# by the next job
	previous_jobid=$jobid
      fi
    else			# ... run on Docker
      docker-compose $COMPOSE_FILES -p nhm run --rm $svc $*	
    fi
} # run

COMPOSE_FILES="-f docker-compose.yml"

if [ $hpc = 0 ]; then
  # check for Shifter module
  if ! module list |& grep ' shifter/' > /dev/null 2>&1 ; then
    echo "Loading Shifter module..."
    module load shifter
  fi
fi

# start date is the base name of the last restart file;
# if on HPC ...
if [ $hpc = 0 ]; then
  # ... at the moment, it's easier to get at the Shifter volume by
  # looking in the mount source directory
  RESTART_DATE=`ls /caldera/projects/usgs/water/impd/nhm/NHM-PRMS_CONUS_GF_1_1/restart/*.restart | \
  	        sed 's/^.*\///;s/\.restart$//' | \
	   	sort | tail -1`
else
  # ... use base image to mount the Docker volume and examine its
  # contents
  #
  # TODO: this won't work on Git bash on Windows because it's not a
  # TTY; see https://github.com/docker/for-win/issues/1588
  #
  # Also: the "-v" argument here won't work on Windows; see
  # https://stackoverflow.com/questions/35767929/using-docker-via-windows-console-includes-invalid-characters-pwd-for-a-local-v  
  RESTART_DATE=`docker run -it -v nhm_nhm:/nhm \
  		       -w /nhm/NHM-PRMS_CONUS_GF_1_1/restart \
                       -e TERM=dumb \
		       nhmusgs/base bash -c 'ls -1 *.restart' | \
	   	sort | tail -1 | cut -f1 -d .`
fi

echo "RESTART_DATE: $RESTART_DATE"

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

# if not on HPC ...
if [ $hpc != 0 ]; then
    # ... download HRU and PRMS work area archive files
    run data-loader
fi

# if we want to run the gridmet-current service...
if [ "$GRIDMET_CURRENT_DISABLE" != true ]; then
    run gridmet-current
    if [ $? != 0 ]; then
      exit $?			# no need to continue
    fi
fi

run ncf2cbh
run cbhfiller

# PRMS

# start time is $START_DATE in PRMS start_date datetime format
START_TIME=`date --date $START_DATE +%Y,%m,%d,00,00,00`
# end time is start date + 1 day in PRMS end_date datetime format
END_TIME=`date --date $END_DATE +%Y,%m,%d,00,00,00`
VAR_SAVE_FILE=""
SAVE_VARS_TO_FILE=0

run nhm-prms
run out2ncf
run verifier

# run PRMS service in restart mode

if [ "$GRIDMET_CURRENT_DISABLE" != true ]; then
  # In operational mode, end time is start date + 1 day in PRMS
  # end_date datetime format.
  END_TIME=`date --date "$yesterday -59 days" +%Y,%m,%d,00,00,00`
fi

SAVE_VARS_TO_FILE=1
VAR_SAVE_FILE="/nhm/NHM-PRMS_CONUS_GF_1_1/restart/$SAVE_RESTART_DATE.restart"
run nhm-prms

# TODO: On Docker (i.e., not Shifter) copy PRMS output from Docker
# volume to $OUTPUT_DIR directory on host

# if on HPC ...
if [ $hpc = 0 ]; then
  # ... set as recurring daily job: see
  # https://www.sherlock.stanford.edu/docs/user-guide/running-jobs/#recurring-jobs
  sbatch --job-name=nhm --dependency=singleton \
	 --begin=`date --date=tomorrow +%Y-%m-%dT$BEGIN:00` $0
fi
