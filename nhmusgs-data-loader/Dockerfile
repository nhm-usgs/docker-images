FROM nhmusgs/base:1.0

LABEL maintainer="ashalper@usgs.gov"

# run in debug mode when "-x"
ENV X=""

# TODO: try to move these environment variables to ../nhm.env. They
# are defined here because this is the only place we could find where
# their values are reliably passed into the container.

# HRU data
ENV HRU_DATA_PKG=Data_hru_shp_gfv11_v1.zip
ENV HRU_SOURCE=ftp://ftpext.usgs.gov/pub/cr/co/denver/BRR-CR/pub/rmcd/${HRU_DATA_PKG}

# PRMS data file archive
ENV PRMS_DATA_PKG=NHM-PRMS_CONUS_GF_1_1_v5.1.0.4.zip
ENV PRMS_SOURCE=ftp://ftpext.usgs.gov/pub/cr/co/denver/BRR-CR/pub/rmcd/${PRMS_DATA_PKG}

COPY --chown=nhm data-loader /usr/local/bin

RUN chmod 744 /usr/local/bin/data-loader

USER $USER

WORKDIR /home/$USER

ENTRYPOINT /usr/local/bin/data-loader
