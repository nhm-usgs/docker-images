FROM nhmusgs/base

LABEL maintainer="ashalper@usgs.gov"

ARG VERSION_TAG_PRMS=5.0.0

# Build PRMS
RUN git -c advice.detachedHead=false clone \
    https://github.com/nhm-usgs/prms.git --branch $VERSION_TAG_PRMS \
    --depth=1 $NHM_SOURCE_DIR/prms && \
    cd $NHM_SOURCE_DIR/prms && \
    make && \
    rm -rf .git || true && \
    rm .gitignore || true && \
    rm Makefile || true && \
    rm makelist || true

COPY --chown=nhm prms /usr/local/bin

RUN chmod 744 /usr/local/bin/prms && \
    chown -R $USER $NHM_SOURCE_DIR/prms

USER $USER

WORKDIR /home/$USER

ENV RESTART=false

ENTRYPOINT ["/usr/local/bin/prms"]
