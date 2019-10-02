FROM nhmusgs/base:latest

LABEL maintainer="ashalper@usgs.gov"

ARG VERSION_TAG_PRMS=5.0.0

# Build PRMS
RUN git clone https://github.com/nhm-usgs/prms.git --branch $VERSION_TAG_PRMS --depth=1 $SOURCE_DIR/prms && \
    cd $SOURCE_DIR/prms && \
    make && \
    rm -rf .git || true && \
    rm .gitignore || true && \
    rm Makefile || true && \
    rm makelist || true

COPY prms /usr/local/bin

RUN chown -R $USER:$USER $SOURCE_DIR/prms && \
  chmod 744 /usr/local/bin/prms

USER $USER

WORKDIR /home/$USER

ENV RESTART=false

ENTRYPOINT ["/bin/bash", "-c", "/usr/local/bin/prms"]
