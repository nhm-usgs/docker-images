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
# Purpose - Simulate NHM run on Docker and Shifter, as might be done
#           by Jenkins.
#
# Authors - Ivan Suftin, Richard McDonald, Andrew Halper
#

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
	      "`yq r docker-compose.yml services.$svc.build.context`/submit.sl")
      else
	# ...start job with the requirement that the previous job
	# completed successfully (exit code 0)
	jobid=$(sbatch --parsable --job-name=$svc \
		       --dependency=afterok:$previous_jobid \
		       --kill-on-invalid-dep=yes \
	      "`yq r docker-compose.yml services.$svc.build.context`/submit.sl")

	# set current jobid to previous_jobid to be used as a dependency
	# by the next job
	previous_jobid=$jobid
      fi
    else			# ... run on Docker
      docker-compose $COMPOSE_FILES -p nhm run --rm $svc $*
    fi
} # run

echo "Checking if HRU data is downloaded..."
# if the HRU shapefiles have not been downloaded yet ...
if [ `docker run -it -v nhm_nhm:/nhm -e TERM=dumb nhmusgs/base \
      sh -c 'test -e /nhm/gridmetetl/nhm_hru_data_gfv11 ; printf $?'` = 1 ]
then
    echo "HRU data needs to be downloaded"
    docker run -it -v nhm_nhm:/nhm -w /nhm -w /nhm/gridmetetl nhmusgs/base \
	   sh -c "wget --waitretry=3 --retry-connrefused $HRU_SOURCE ; \
	         unzip $HRU_DATA_PKG ; \
           chown -R nhm /nhm/gridmetetl ; \
           chmod -R 766 /nhm/gridmetetl"
fi

echo "User is $USER"

echo "Checking if PRMS data is downloaded..."
# if the PRMS data is not on the Docker volume yet ...
if [ `docker run -it -v nhm_nhm:/nhm -e TERM=dumb nhmusgs/base \
      sh -c 'test -e /nhm/NHM-PRMS_CONUS_GF_1_1 ; printf $?'` = 1 ]; then
  # ... download it
  echo "PRMS data needs to be downloaded"
  docker run -it -v nhm_nhm:/nhm -w /nhm nhmusgs/base \
	 sh -c "wget --waitretry=3 --retry-connrefused $PRMS_SOURCE ; \
	        unzip $PRMS_DATA_PKG ; \
          chown -R nhm /nhm/NHM-PRMS_CONUS_GF_1_1 ; \
          chmod -R 766 /nhm/NHM-PRMS_CONUS_GF_1_1"
fi

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
  RESTART_DATE=`ls $SOURCE/NHM-PRMS_CONUS_GF_1_1/restart/*.restart | \
  	        sed 's/^.*\///;s/\.restart$//' | \
	   	sort | tail -1`
else
  # ... use base image to mount the Docker volume and examine its
  # contents
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

if [ "$FRCST_END_DATE" = "" ]; then
    FRCST_END_DATE=`date --date "$yesterday +29 days" --rfc-3339='date'`
fi

F_END_TIME=`date --date $FRCST_END_DATE +%Y,%m,%d,00,00,00`

echo "FORECAST_END_DATE: $FRCST_END_DATE"
echo "FORECAST_END_TIME: $F_END_TIME"

# if we want to run the Gridmet service...
if [ "$GRIDMET_DISABLE" != true ]; then
    run gridmet
fi

if [ "$FORECAST_ENABLE" != false ]; then
  # Create Forecast Input files
  S2S_DATE=$END_DATE
  run gridmets2s

  NCF_IDIR=$S2S_NCF_IDIR
  NCF_DATE=$END_DATE
  NCF_PREFIX=$S2S_NCF_PREFIX
  run ncf2cbh

  CBH_IDIR=$S2S_CBH_IDIR
  CBH_ODIR=$S2S_CBH_ODIR
  run cbhfiller
fi

# Create daily operation input files
run gridmetetl
NCF_IDIR=$OP_NCF_IDIR
NCF_PREFIX=$OP_NCF_PREFIX
NCF_DATE=$END_DATE
run ncf2cbh

CBH_IDIR=$OP_CBH_IDIR
CBH_ODIR=$OP_CBH_ODIR
run cbhfiller

# PRMS

# start time is $START_DATE in PRMS start_date datetime format
START_TIME=`date --date $START_DATE +%Y,%m,%d,00,00,00`
# end time is start date + 1 day in PRMS end_date datetime format
END_TIME=`date --date $END_DATE +%Y,%m,%d,00,00,00`

F_END_TIME = `date --date $FRCST_END_DATE +%Y,%m,%d,00,00,00`

echo "FORECAST_END_TIME: $F_END_TIME"
# VAR_SAVE_FILE=""
# SAVE_VARS_TO_FILE=0

PRMS_START_TIME=$START_TIME
PRMS_END_TIME=$END_TIME
PRMS_INIT_VARS_FROM_FILE=1
PRMS_RESTART_DATE=$RESTART_DATE
PRMS_VAR_INIT_FILE="/nhm/NHM-PRMS_CONUS_GF_1_1/restart/$RESTART_DATE.restart"
PRMS_SAVE_VARS_TO_FILE=1
PRMS_VAR_SAVE_FILE="/nhm/NHM-PRMS_CONUS_GF_1_1/forecast/restart/$END_DATE.restart"
PRMS_CONTROL_FILE=$OP_PRMS_CONTROL_FILE

PRMS_RUN_TYPE=0
run nhm-prms

OUT_NCF_DIR=$OP_DIR
# run out2ncf
run verifier

if [ "$FORECAST_ENABLE" != false ]; then
  # run PRMS forecast
  PRMS_START_TIME=$END_TIME
  PRMS_END_TIME=$F_END_TIME
  PRMS_INIT_VARS_FROM_FILE=1
  PRMS_RESTART_DATE=$END_DATE
  PRMS_VAR_INIT_FILE="/nhm/NHM-PRMS_CONUS_GF_1_1/forecast/restart/$END_DATE.restart"
  PRMS_SAVE_VARS_TO_FILE=0
  PRMS_VAR_SAVE_FILE="None"
  PRMS_CONTROL_FILE=$S2S_PRMS_CONTROL_FILE
  PRMS_RUN_TYPE=1
  run nhm-prms
  OUT_NCF_DIR=$S2S_DIR
  # run out2ncf
fi

# run PRMS service in restart mode
# Run PRMS to increment the operational restart file by +1 day
# In operational mode, end time is start date + 1 day in PRMS end_date
# datetime format.
if [ "$GRIDMET_DISABLE" != true ]; then
    END_TIME=`date --date "$yesterday -59 days" +%Y,%m,%d,00,00,00`
fi

PRMS_START_TIME=$START_TIME
PRMS_END_TIME=$END_TIME
PRMS_INIT_VARS_FROM_FILE=1
PRMS_VAR_INIT_FILE="/nhm/NHM-PRMS_CONUS_GF_1_1/restart/$RESTART_DATE.restart"
PRMS_SAVE_VARS_TO_FILE=1
PRMS_VAR_SAVE_FILE="/nhm/NHM-PRMS_CONUS_GF_1_1/restart/$SAVE_RESTART_DATE.restart"
PRMS_CONTROL_FILE=$OP_PRMS_CONTROL_FILE

PRMS_RUN_TYPE=0
run nhm-prms

# copy PRMS output from Docker volume to $OUTPUT_DIR directory on host
echo "Pipeline has completed. Will copy output files from Docker volume."
echo "Output files will show up in the \"$OUTPUT_DIR\" directory."
docker build -t nhmusgs/volume-mounter - <<EOF
FROM alpine
CMD
EOF
docker container create --name volume_mounter -v nhm_nhm:/nhm \
       nhmusgs/volume-mounter
docker cp volume_mounter:/nhm/NHM-PRMS_CONUS_GF_1_1/output $OUTPUT_DIR
docker cp volume_mounter:/nhm/NHM-PRMS_CONUS_GF_1_1/input $OUTPUT_DIR
docker cp volume_mounter:/nhm/NHM-PRMS_CONUS_GF_1_1/restart $OUTPUT_DIR
docker cp volume_mounter:/nhm/NHM-PRMS_CONUS_GF_1_1/forecast/input $FRCST_DIR
docker cp volume_mounter:/nhm/NHM-PRMS_CONUS_GF_1_1/forecast/output $FRCST_DIR
docker cp volume_mounter:/nhm/NHM-PRMS_CONUS_GF_1_1/forecast/restart $FRCST_DIR
docker rm volume_mounter

# # clean up
# for d in input output; do
#   docker run -v nhm_nhm:/nhm -w /nhm/NHM-PRMS_CONUS_GF_1_1/$d \
# 	 nhmusgs/volume-mounter sh -c 'rm -f *.nc'
# done
# for d in input output; do
#   docker run -v nhm_nhm:/nhm -w /nhm/NHM-PRMS_CONUS_GF_1_1/forecast/$d \
# 	 nhmusgs/volume-mounter sh -c 'rm -f *.nc'
# done
# docker run -v nhm_nhm:/nhm -w /nhm/gridmetetl/nhm_hru_data_gfv11 \
#        nhmusgs/volume-mounter sh -c 'rm -f *.nc'

# if on HPC ...
if [ $hpc = 0 ]; then
  # ... set as recurring daily job: see
  # https://www.sherlock.stanford.edu/docs/user-guide/running-jobs/#recurring-jobs
  sbatch --job-name=nhm --dependency=singleton \
	 --begin=`date --date=tomorrow +%Y-%m-%dT16:00:00` $0
fi
