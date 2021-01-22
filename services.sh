# U.S. Geological Survey
#
# File - services.sh
#
# Purpose - Parse services' names from docker-compose.yml.
#
# Authors -  Andrew Halper
#

services () {
  # this is only guaranteed to run with yq 3.2.1; yq 4.x query
  # language is different
  yq r -p p docker-compose.yml 'services.*' | sed 's/services.//' | \
    grep -v base_image
}
