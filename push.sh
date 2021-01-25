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

. services.sh			# docker-compose.yml parser function

for svc in `services`; do
  docker push "nhmusgs/$svc" &
done
wait
