FROM nhmusgs/base:1.0

LABEL maintainer="ashalper@usgs.gov"

USER $USER

WORKDIR $NHM_SOURCE_DIR

ENTRYPOINT \
  ["/opt/conda/bin/python", "-u", "/usr/local/src/gridmetetl/gridmetetl/Gridmet_current.py"]
