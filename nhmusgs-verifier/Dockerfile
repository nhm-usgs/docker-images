FROM nhmusgs/base:1.0

LABEL maintainer="ashalper@usgs.gov"

ARG VERSION_TAG_VERIFY=0.1.1

# TODO: value of this needs to be computed and passed in; see also base
# image Dockerfile.
ARG certificate='--no-check-certificate'

RUN wget $certificate -P $NHM_SOURCE_DIR -nv \
    https://github.com/nhm-usgs/onhm-verify-eval/archive/$VERSION_TAG_VERIFY.tar.gz 

RUN cd $NHM_SOURCE_DIR && tar -xzf $VERSION_TAG_VERIFY.tar.gz
RUN mv $NHM_SOURCE_DIR/onhm-verify-eval-$VERSION_TAG_VERIFY $NHM_SOURCE_DIR/onhm-verify-eval
RUN rm $NHM_SOURCE_DIR/$VERSION_TAG_VERIFY.tar.gz

USER $USER

WORKDIR /home/$USER

ENTRYPOINT ["/bin/bash", "-c", "/usr/local/bin/verifier"]
