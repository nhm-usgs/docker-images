# U.S. Geological Survey
#
# File - services.sh
#
# Purpose - Parse services' names from docker-compose.yml.
#
# Authors -  Andrew Halper
#

services () {
    tail -n +8 docker-compose.yml | grep '^  [a-z]' | tr -d '[ :]'
}
