FROM nhmusgs/base:1.1

LABEL maintainer="ashalper@usgs.gov"

COPY --chown=nhm verifier /usr/local/bin
RUN chmod 744 /usr/local/bin/verifier

ARG VERSION_TAG_VERIFY=0.1.1

RUN wget --no-check-certificate -P $NHM_SOURCE_DIR -nv \
    https://github.com/nhm-usgs/onhm-verify-eval/archive/$VERSION_TAG_VERIFY.tar.gz 

RUN cd $NHM_SOURCE_DIR && tar -xzf $VERSION_TAG_VERIFY.tar.gz
RUN mv $NHM_SOURCE_DIR/onhm-verify-eval-$VERSION_TAG_VERIFY $NHM_SOURCE_DIR/onhm-verify-eval
RUN rm $NHM_SOURCE_DIR/$VERSION_TAG_VERIFY.tar.gz

USER $USER

WORKDIR /home/$USER

ENTRYPOINT ["/bin/bash", "-c", "/usr/local/bin/verifier"]
