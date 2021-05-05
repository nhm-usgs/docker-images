FROM nhmusgs/base

LABEL maintainer="ashalper@usgs.gov"

USER $USER

WORKDIR /home/$USER

ENTRYPOINT \
  ["/opt/conda/bin/python", "-u", "/usr/local/src/onhm-runners/out2ncf/prms_outputs2a_ncf.py", $OUT_NCF_DIR]
