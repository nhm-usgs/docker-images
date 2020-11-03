FROM nhmusgs/base

LABEL maintainer="ashalper@usgs.gov"

ARG VERSION_TAG_GRIDMET=v0.24

# check out source from repo.
RUN git -c advice.detachedHead=false clone --depth=1 --branch $VERSION_TAG_GRIDMET \
    https://github.com/nhm-usgs/gridmetetl.git \
    $NHM_SOURCE_DIR/gridmetetl

USER $USER

WORKDIR $NHM_SOURCE_DIR

ENTRYPOINT \
  ["/opt/conda/bin/python", "-u", "gridmetetl/gridmetetl/Gridmet_current.py"]
