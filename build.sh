#! /bin/bash
#
# U.S. Geological Survey
#
# File - build.sh
#
# Purpose - Build NHM Docker containers, for publishing on Docker Hub.
#
# Authors -  Andrew Halper, Ivan Suftin
#

docker-compose build base_image
docker-compose build -f docker-compose.yml \
	       -f docker-compose-testing.yml data_loader
for svc in data_loader gridmet ofp ncf2cbh nhm-prms out2ncf verifier; do
    docker-compose build "$svc"
done
