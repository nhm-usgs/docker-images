#! /bin/bash
#
# U.S. Geological Survey
#
# File - compose-test-shifter.sh
#
# Purpose - Simulate NHM run, as might be done by Jenkins, using Shifter.
#
# Authors - Ivan Suftin, Richard McDonald, Andrew Halper
#

set -e

. ./nhm.env			# environment variables file

# docker-compose $COMPOSE_FILES -p nhm run --rm $svc $*
run="salloc -N 1 -n 1 -A wbeep --image"

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

$run nhmusgs/data-loader

# if we want to run the Gridmet service...
if [ "$GRIDMET_DISABLE" != true ]; then
    # ...do that
    $run nhmusgs/gridmet
    if [ $? != 0 ]; then
        echo 'Gridmet data is not available - process exiting'
        exit 1
    fi
fi
