# U.S. Geological Survey
#
# File - Dockerfile
#
# Purpose - Dockerfile for NHM Gridmet container.
#
# Author - Andrew Halper
#

FROM nhmusgs/base

LABEL maintainer="ashalper@usgs.gov"

# check out source from repo.
RUN git clone --depth=1 --branch v0.1.5 \
    https://github.com/nhm-usgs/onhm-fetcher-parser.git $SOURCE_DIR/onhm-fetcher-parser

# entrypoint
COPY --chown=nhm gridmet /usr/local/bin

RUN chmod 744 /usr/local/bin/gridmet

USER $USER

WORKDIR /home/$USER

ENTRYPOINT ["/bin/bash", "-c", "/usr/local/bin/gridmet"]
