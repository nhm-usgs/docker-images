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

for image in `awk '/ image:/ { if (match($2, "nhmusgs/base") == 0) print $2}' docker-compose.yml`; do
  shifterimg pull $image
done
