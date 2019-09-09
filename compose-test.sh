#!/bin/bash

set -e

echo "Building necessary Docker images"
docker-compose build base_image
docker-compose build --parallel

HRU_DATA_PKG="Data_hru_shp.tar.gz"
PRMS_DATA_PKG="NHM-PRMS_CONUS.zip"
PRMS_SOURCE=ftp://ftpext.usgs.gov/pub/cr/co/denver/BRR-CR/pub/markstro/NHM-PRMS_CONUS.zip
HRU_SOURCE=ftp://ftpext.usgs.gov/pub/cr/co/denver/BRR-CR/pub/rmcd/Data_hru_shp.tar_v2.gz

echo "Checking if HRU data is downloaded..."
if [[ ! -f "data/${HRU_DATA_PKG}" ]]; then
    echo "HRU data needs to be downloaded"
    wget --waitretry=3 --retry-connrefused "${HRU_SOURCE}" -O "data/${HRU_DATA_PKG}"
fi

echo "Checking if PRMS data is downloaded..."
if [[ ! -f "data/${PRMS_DATA_PKG}" ]]; then
    echo "PRMS data needs to be downloaded"
    wget --waitretry=3 --retry-connrefused "${PRMS_SOURCE}" -O "data/${PRMS_DATA_PKG}"
fi

COMPOSE_FILES="-f docker-compose.yml -f docker-compose-testing.yml"
echo "Beginning run. If this fails at any point, run the following command:"
echo "docker-compose $COMPOSE_FILES down"
for svc in data_loader ofp ncf2cbh nhm-prms out2ncf verifier; do
    echo ""
    echo "Running ${svc}..."
    docker-compose $COMPOSE_FILES run --rm $svc
done
docker-compose $COMPOSE_FILES down

echo "Pipeline has completed. Will copy output files from Docker volume"
echo "Output files will show up in the \"output\" directory"
docker build -t nothing - <<EOF
FROM alpine
CMD
EOF

docker container create --name dummy -v app_nhm:/test nothing
docker cp dummy:/test/ofp/Output .
docker rm dummy

echo "If you wish to re-start clean, run the following:"
echo "docker system prune -f"
echo "docker network prune -f"
