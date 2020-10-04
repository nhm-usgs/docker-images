#! /bin/bash
#
# U.S.  Geological Survey
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
docker cp dummy:/test/NHM-PRMS_CONUS/output .
docker cp dummy:/test/NHM-PRMS_CONUS/input .
docker cp dummy:/test/NHM-PRMS_CONUS/restart .
docker rm dummy
