FROM nhmusgs/base

LABEL maintainer="ashalper@usgs.gov"

# ARG VERSION_TAG_OFP=v0.1.6
ARG VERSION_TAG_GMETL=v0.21

# Build ONHM Fetcher Parser
RUN git -c advice.detachedHead=false clone --depth=1 --branch $VERSION_TAG_GMETL \
    https://github.com/nhm-usgs/gridmetetl.git $NHM_SOURCE_DIR/gridmetetl && \
    cd $NHM_SOURCE_DIR/gridmetetl && \
    rm -rf .git || true && \
    rm -rf .idea || true && \
    rm .gitignore || true

# ofp script
COPY --chown=nhm ofp /usr/local/bin

RUN chmod 744 /usr/local/bin/ofp

USER $USER

WORKDIR /home/$USER

ENTRYPOINT ["/bin/bash", "-c", "/usr/local/bin/ofp"]
