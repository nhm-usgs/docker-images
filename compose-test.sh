#! /bin/bash
#
# U.S. Geological Survey
#
# File - compose-test.sh
#
# Purpose - Simulate NHM run, as might be done by Jenkins.
#
# Authors - Ivan Suftin, Richard McDonald, Andrew Halper
#

set -e

. ./nhm.env			# environment variables file

# encapsulate some container running boiler-plate
run () {
    svc=$1
    shift

    echo ""
    echo "Running $svc..."
    # if running a Shifter image on MPI...
    if [ "$SHIFTER" = true ]; then
	# ...fix much naming inconsistency in this directory...
	dir=`echo $svc | \
	   sed 's/data_loader/nhmusgs-data-loader/;\
	        s/nhm-prms/nhmusgs-nhm-prms/;\
	        s/out2ncf/nhmusgs-nhm-out2ncf/'`
	# ...and submit as a Slurm batch script.
	sbatch -W ./$dir/submit.sl
    else
	docker-compose $COMPOSE_FILES -p nhm run --rm $svc $*
    fi
} # run

if [ "$SHIFTER" != true ]; then
    echo "Building necessary Docker images"
    docker-compose build base_image
    docker-compose build --parallel
fi

echo "Checking if HRU data is downloaded..."
if [ ! -d data ]; then
    mkdir data
fi
if [ ! -f "data/${HRU_DATA_PKG}" ]; then
    echo "HRU data needs to be downloaded"
    wget --waitretry=3 --retry-connrefused "${HRU_SOURCE}" \
	-O "data/${HRU_DATA_PKG}"
fi

echo "Checking if PRMS data is downloaded..."
if [ ! -f "data/${PRMS_DATA_PKG}" ]; then
    echo "PRMS data needs to be downloaded"
    wget --waitretry=3 --retry-connrefused "${PRMS_SOURCE}" \
	-O "data/${PRMS_DATA_PKG}"
fi

echo "Beginning run."
if [ "$SHIFTER" != true ]; then
    COMPOSE_FILES="-f docker-compose.yml -f docker-compose-testing.yml"
    echo "If this fails at any point, run the following command:"
    echo "docker-compose $COMPOSE_FILES down"
fi

# call run() function above
run data_loader

# if we want to run the Gridmet service...
if [ "$GRIDMET_DISABLE" != true ]; then
    # ...do that
    run gridmet
    if [ $? != 0 ]; then
	echo 'Gridmet data is not available - process exiting'
	exit 1
    fi
fi

# if we want to run the ofp service...
if [ "$OFP_DISABLE" != true ]; then
    run ofp
fi

run ncf2cbh

# PRMS
run nhm-prms --env END_DATE="$END_DATE"

# run these two services
for svc in out2ncf verifier; do
    run "$svc"
done

# run PRMS service again in restart mode
export RESTART=true
run nhm-prms

if [ "$SHIFTER" != true ]; then
    docker-compose $COMPOSE_FILES down
fi

# TODO: need something that will run on Shifter/MPI here.
if [ "$SHIFTER" != true ]; then
    # copy PRMS output from Docker volume to directory on host
    echo "Pipeline has completed. Will copy output files from Docker volume"
    echo "Output files will show up in the \"output\" directory"

    docker build -t nothing - <<EOF
FROM alpine
CMD
EOF
    docker container create --name dummy -v nhm_nhm:/test nothing
    docker cp dummy:/test/ofp/Output .
    docker rm dummy

    echo "If you wish to re-start clean, run the following:"
    echo "docker system prune -f"
    echo "docker network prune -f"
fi
