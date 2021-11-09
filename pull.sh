#! /bin/bash
#
# U.S. Geological Survey
#
# File - build.sh
#
# Purpose - Download NHM Docker images and convert to Shifter.
#
# Authors -  Andrew Halper
#

# See https://hub.docker.com/orgs/nhmusgs/repositories and
# https://docs.nersc.gov/programming/shifter/how-to-use/ for more.

for image in `grep 'image: nhmusgs' docker-compose.yml | cut -d ' ' -f6`; do
  shifterimg pull $image
done
