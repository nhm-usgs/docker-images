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

for image in `awk '/ image: / { if (!match($2, "nhmusgs/base:")) \
                                   print $2 }' docker-compose.yml` ; do
  docker push $image &
done
wait
