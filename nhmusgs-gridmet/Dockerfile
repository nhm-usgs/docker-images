FROM nhmusgs/base

LABEL maintainer="ashalper@usgs.gov"

ARG VERSION_TAG_GRIDMET=v0.1.6

COPY --chown=nhm gridmet /usr/local/bin

RUN chmod 744 /usr/local/bin/gridmet

# check out source from repo.
RUN git -c advice.detachedHead=false clone --depth=1 --branch $VERSION_TAG_GRIDMET \
    https://github.com/nhm-usgs/onhm-fetcher-parser.git \
    $NHM_SOURCE_DIR/onhm-fetcher-parser

USER $USER

WORKDIR $NHM_SOURCE_DIR

ENTRYPOINT ["/usr/local/bin/gridmet"]
