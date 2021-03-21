FROM nhmusgs/base

LABEL maintainer="rmcd@usgs.gov"

# ARG VERSION_TAG_OFP=v0.1.6
ARG VERSION_TAG_GMETL_CFSV2=0.1

# Build ONHM Fetcher Parser
RUN git -c advice.detachedHead=false clone --depth=1 --branch $VERSION_TAG_GMETL_CFSV2 \
    https://github.com/rmcd-mscb/gridmet_cfsv2.git $NHM_SOURCE_DIR/gridmetetl && \
    cd $NHM_SOURCE_DIR/gridmetetl && \
    rm -rf .git || true && \
    rm -rf .idea || true && \
    rm .gitignore || true

# ofp script
COPY --chown=nhm gmetl_cfsv2 /usr/local/bin

RUN chmod 744 /usr/local/bin/gmetl_cfsv2

USER $USER

WORKDIR /home/$USER

ENTRYPOINT ["/bin/bash", "-c", "/usr/local/bin/gmetl_cfsv2"]
