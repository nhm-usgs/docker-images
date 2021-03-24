FROM nhmusgs/base:1.0

LABEL maintainer="ashalper@usgs.gov"

ARG VERSION_TAG_PRMS=5.1.0.4_linux

# TODO: replace --no-check-certificate here with logic to work around
# DOI SSL intercept. See
# https://github.com/usgs/best-practices/blob/master/ssl/WorkingWithinSSLIntercept.md
RUN wget --no-check-certificate -P $NHM_SOURCE_DIR -nv \
    https://github.com/nhm-usgs/prms/archive/$VERSION_TAG_PRMS.tar.gz

RUN cd $NHM_SOURCE_DIR && tar -xzf $VERSION_TAG_PRMS.tar.gz
RUN mv $NHM_SOURCE_DIR/prms-$VERSION_TAG_PRMS $NHM_SOURCE_DIR/prms
RUN rm $NHM_SOURCE_DIR/$VERSION_TAG_PRMS.tar.gz
# Build PRMS
RUN cd $NHM_SOURCE_DIR/prms && \
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

ENTRYPOINT ["/bin/bash", "-c", "/usr/local/bin/prms"]
