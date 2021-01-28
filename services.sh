# U.S. Geological Survey
#
# File - services.sh
#
# Purpose - Parse services' names from docker-compose.yml.
#
# Authors -  Andrew Halper
#

services () {
  # TODO: find a yq-way to remove prefix " -" here
  yq -M e '.services | keys' docker-compose.yml | sed 's/- //'
}
