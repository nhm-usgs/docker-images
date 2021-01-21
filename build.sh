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

# this is only guaranteed to run with yq 3.2.1; yq 4.x query language
# is different
for svc in `yq r -p p docker-compose.yml 'services.*' | sed 's/services.//'`; do
  docker-compose build "$svc"
done
