FROM nhmusgs/base:1.1

LABEL maintainer="ashalper@usgs.gov"

COPY --chown=nhm gridmet-current /usr/local/bin
RUN chmod 744 /usr/local/bin/gridmet-current

USER $USER

WORKDIR $NHM_SOURCE_DIR

ENTRYPOINT ["/bin/bash", "-c", "/usr/local/bin/gridmet-current"]
