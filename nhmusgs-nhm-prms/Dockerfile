FROM nhmusgs/base

LABEL maintainer="ashalper@usgs.gov"

ARG VERSION_TAG_PRMS=prms_5.1.0.10

ARG HDF5_LDFLAGS=-L/usr/lib/x86_64-linux-gnu
ARG NC_CPPFLAGS=-I/usr/include
ARG NC_LDFLAGS=-L/usr/lib

# Build PRMS
RUN git -c advice.detachedHead=false clone \
    https://github.com/ashalper-usgs/prms.git --branch $VERSION_TAG_PRMS \
    --depth=1 $NHM_SOURCE_DIR/prms && \
    cd $NHM_SOURCE_DIR/prms && \
    make

COPY --chown=nhm prms /usr/local/bin

RUN chmod 744 /usr/local/bin/prms && \
    chown -R $USER $NHM_SOURCE_DIR/prms

USER $USER

WORKDIR /home/$USER

ENTRYPOINT ["/bin/bash", "-c", "/usr/local/bin/prms"]
