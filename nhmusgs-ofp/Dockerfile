FROM nhmusgs/base:latest

LABEL maintainer="ashalper@usgs.gov"

ARG VERSION_TAG_OFP=v0.1.6

# Build ONHM Fetcher Parser
RUN git clone --depth=1 --branch $VERSION_TAG_OFP \
    https://github.com/nhm-usgs/onhm-fetcher-parser.git $SOURCE_DIR/onhm-fetcher-parser && \
    cd $SOURCE_DIR/onhm-fetcher-parser && \
    rm -rf .git || true && \
    rm .gitignore || true

COPY ofp /usr/local/bin

RUN chown $USER:$USER /usr/local/bin/ofp && \
  chmod 744 /usr/local/bin/ofp

USER $USER

WORKDIR /home/$USER

ENV NUMDAYS=60
ENV START_DATE=2019-01-01
ENV END_DATE=2019-01-02

ENTRYPOINT ["/bin/bash", "-c", "/usr/local/bin/ofp"]
