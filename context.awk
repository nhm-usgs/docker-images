#  U.S. Geological Survey
# 
#  File - context.awk
#
#  Purpose - Query relationship between service name and "context" in
#            docker-compose.yml.
#
#  Author - Andrew Halper <ashalper@usgs.gov>
#

# TODO: it would be smarter to use yq
# [https://github.com/mikefarah/yq] for this, but it is not installed
# on denali.

/^  [a-z_-]*:/ {
    # if past the "volumes" section of docker-compose.yml ...
    if (4 < NR) {
	service = $1;
	sub(":", "", service)
    }
}
/^      context:/ {
    if (service == i) {
	print $2;
	exit;
    }
}
