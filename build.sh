#! /bin/bash
#
# U.S. Geological Survey
#
# File - build.sh
#
# Purpose - Build NHM Docker containers.
#
# Authors -  Andrew Halper, Ivan Suftin
#

docker-compose build base_image
for svc in data_loader gridmet ofp ncf2cbh nhm-prms out2ncf verifier; do
  docker-compose build "$svc"
done
