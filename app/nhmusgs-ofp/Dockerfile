FROM nhmusgs/base

LABEL maintainer="ashalper@usgs.gov"

# Build ONHM Fetcher Parser
RUN git clone --depth=1 --branch v0.1.0 \
    https://github.com/nhm-usgs/onhm-fetcher-parser.git $SOURCE_DIR/onhm-fetcher-parser && \
    cd $SOURCE_DIR/onhm-fetcher-parser && \
    rm -rf .git || true && \
    rm -rf .idea || true && \
    rm .gitignore || true 

# ofp script
COPY --chown=nhm ofp /usr/local/bin

RUN mkdir -p /var/lib/nhm/ofp/Output

RUN chmod 744 /usr/local/bin/ofp 

USER $USER

WORKDIR /home/$USER

ENV NUMDAYS=60

# convenience soft-links
RUN ln -s $SOURCE_DIR/onhm-fetcher-parser $HOMEDIR/onhm-fetcher-parser && \
    ln -s /var/lib/nhm $HOMEDIR/nhm

# ...and remain running
ENTRYPOINT ["/bin/bash", "-c", "/usr/local/bin/ofp"]