FROM nhmusgs/base

LABEL maintainer="ashalper@usgs.gov"

COPY --chown=nhm nhm /usr/local/bin

RUN chmod 744 /usr/local/bin/nhm

USER $USER

WORKDIR /home/$USER

ENV NUMDAYS=60

RUN ln -s $SOURCE_DIR/onhm-fetcher-parser $HOMEDIR/onhm-fetcher-parser && \
    ln -s /var/lib/nhm $HOMEDIR/nhm

ENTRYPOINT ["/bin/bash", "-c", "/usr/local/bin/nhm"]