FROM nhmusgs/base:1.0

LABEL maintainer="ashalper@usgs.gov"

USER $USER

WORKDIR /home/$USER

ENV NUMDAYS=60

ENTRYPOINT \
  ["/opt/conda/bin/python", "-u", "/usr/local/src/onhm-runners/ncf2cbh/ncf2cbh_gfv11.py", "/nhm/NHM-PRMS_CONUS_GF_1_1/input/"]