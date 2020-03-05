FROM nhmusgs/base

LABEL maintainer="ashalper@usgs.gov"

USER $USER

WORKDIR /home/$USER

ENV NUMDAYS=60

ENTRYPOINT \
  ["/opt/conda/bin/python", "-u", "/usr/local/src/onhm-runners/ncf2cbh/ncf2cbh.py", "/nhm/NHM-PRMS_CONUS/input/"]