FROM nhmusgs/base

LABEL maintainer="ashalper@usgs.gov"

ARG VERSION_TAG_PRMS=5.0.0

USER $USER

WORKDIR /home/$USER

RUN ln -s $SOURCE_DIR/prms $HOMEDIR/prms && \
    ln -s /var/lib/nhm $HOMEDIR/nhm

ENTRYPOINT ["/bin/bash", "-c", "/usr/local/bin/nhm-restart"]
