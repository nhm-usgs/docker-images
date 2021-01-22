#! /bin/bash
#
# U.S. Geological Survey
#
# File - build.sh
#
# Purpose - Build NHM Docker containers.
#
# Authors -  Andrew Halper
#

. services.sh			# docker-compose.yml parser funct.

for svc in `services`; do
  docker-compose build "$svc"
done
