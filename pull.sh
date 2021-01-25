#! /bin/bash
#
# U.S. Geological Survey
#
# File - pull.sh
#
# Purpose - Download NHM Docker images and convert to Shifter.
#
# Authors -  Andrew Halper
#

# See https://hub.docker.com/orgs/nhmusgs/repositories and
# https://docs.nersc.gov/programming/shifter/how-to-use/ for more.

# this is only guaranteed to run with yq 3.2.1; yq 4.x query
# language is different
for image in `yq r docker-compose.yml 'services.*.image'`; do
  shifterimg pull $image
done
