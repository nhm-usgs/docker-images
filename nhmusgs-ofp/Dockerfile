FROM nhmusgs/base

LABEL maintainer="ashalper@usgs.gov"

ARG VERSION_TAG_OFP=v0.1.6

# Build ONHM Fetcher Parser
RUN git -c advice.detachedHead=false clone --depth=1 --branch $VERSION_TAG_OFP \
    https://github.com/nhm-usgs/onhm-fetcher-parser.git $SOURCE_DIR/onhm-fetcher-parser && \
    cd $SOURCE_DIR/onhm-fetcher-parser && \
    rm -rf .git || true && \
    rm -rf .idea || true && \
    rm .gitignore || true

# ofp script
COPY --chown=nhm ofp /usr/local/bin

RUN chmod 744 /usr/local/bin/ofp

USER $USER

WORKDIR /home/$USER

ENTRYPOINT ["/usr/local/bin/ofp"]
