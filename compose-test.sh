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

    echo ""
    echo "Running $svc..."
    docker-compose $COMPOSE_FILES -p nhm run --rm $svc
} # run

echo "Building necessary Docker images"
docker-compose build base_image
docker-compose build --parallel

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

COMPOSE_FILES="-f docker-compose.yml -f docker-compose-testing.yml"
echo "Beginning run. If this fails at any point, run the following command:"
echo "docker-compose $COMPOSE_FILES down"

# call run() function above
run data_loader
run gridmet

if [ $? != 0 ]; then
    echo 'Gridmet data is not available - process exiting'
    exit 1
fi

for svc in ofp ncf2cbh nhm-prms out2ncf verifier nhm-restart; do
    run "$svc"
done
docker-compose $COMPOSE_FILES down

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
