FROM nhmusgs/base

LABEL maintainer="ashalper@usgs.gov"

ARG VERSION_TAG_GRIDMET=v0.1.6

# check out source from repo.
RUN git clone --depth=1 --branch $VERSION_TAG_GRIDMET \
    https://github.com/nhm-usgs/onhm-fetcher-parser.git \
    $SOURCE_DIR/onhm-fetcher-parser

USER $USER

WORKDIR $SOURCE_DIR

ENTRYPOINT \
  ["/opt/conda/bin/python", "-u", "onhm-fetcher-parser/pkg/Gridmet_current.py"]
