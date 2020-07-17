#! /bin/bash
#
# U.S. Geological Survey
#
# File - volume_extract
#
# Purpose - Docker script to extract volume solution.
#
# Authors - Ivan Suftin, Richard McDonald, Steven Markstrom,
#           Andrew Halper
#


docker build -t nothing - <<EOF
FROM alpine
CMD
EOF
docker container create --name dummy -v nhm_nhm:/test nothing
docker cp dummy:/test/NHM-PRMS_CONUS_GF_1_1/output .
docker cp dummy:/test/NHM-PRMS_CONUS_GF_1_1/input .
docker cp dummy:/test/NHM-PRMS_CONUS_GF_1_1/restart .
docker rm dummy

