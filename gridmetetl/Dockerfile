FROM nhmusgs/base

LABEL maintainer="ashalper@usgs.gov"

ARG VERSION_TAG_GMETL=0.27

# Build ONHM Fetcher Parser
RUN git -c advice.detachedHead=false clone --depth=1 --branch $VERSION_TAG_GMETL \
    https://github.com/nhm-usgs/gridmetetl.git $NHM_SOURCE_DIR/gridmetetl && \
    cd $NHM_SOURCE_DIR/gridmetetl && \
    rm -rf .git || true && \
    rm -rf .idea || true && \
    rm .gitignore || true

# gridmetetl script
COPY --chown=nhm gridmetetl /usr/local/bin

RUN chmod 744 /usr/local/bin/gridmetetl

USER $USER

WORKDIR /home/$USER

ENTRYPOINT ["/bin/bash", "-c", "/usr/local/bin/gridmetetl"]
