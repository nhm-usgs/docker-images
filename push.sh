#! /bin/bash
#
# U.S. Geological Survey
#
# File - build.sh
#
# Purpose - Publish NHM Docker containers on Docker Hub.
#
# Authors -  Andrew Halper
#

for image in `grep 'image: nhmusgs' docker-compose.yml | cut -d ' ' -f6`; do
  docker push $image &
done
wait
