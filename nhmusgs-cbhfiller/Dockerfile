FROM nhmusgs/base:1.0

LABEL maintainer="ashalper@usgs.gov"

USER $USER

WORKDIR /home/$USER

ENTRYPOINT /opt/conda/bin/python -u \
   /usr/local/src/onhm-runners/cbh_filler/cbh_filler.py \
   "$CBH_IDIR" "$CBH_IDIR" \
   /usr/local/src/onhm-runners/cbh_filler/nhm_id.txt \
   /usr/local/src/onhm-runners/cbh_filler/miss_to_pres_mapping.csv
