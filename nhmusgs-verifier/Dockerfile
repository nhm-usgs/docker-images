FROM nhmusgs/base:1.0

LABEL maintainer="ashalper@usgs.gov"

ARG VERSION_TAG_VERIFY=0.1.1

# TODO: replace --no-check-certificate here with logic to work around
# DOI SSL intercept. See
# https://github.com/usgs/best-practices/blob/master/ssl/WorkingWithinSSLIntercept.md
RUN wget --no-check-certificate -P $NHM_SOURCE_DIR -nv \
    https://github.com/nhm-usgs/onhm-verify-eval/archive/$VERSION_TAG_VERIFY.tar.gz 

RUN cd $NHM_SOURCE_DIR && tar -xzf $VERSION_TAG_VERIFY.tar.gz
RUN mv $NHM_SOURCE_DIR/onhm-verify-eval-$VERSION_TAG_VERIFY $NHM_SOURCE_DIR/onhm-verify-eval
RUN rm $NHM_SOURCE_DIR/$VERSION_TAG_VERIFY.tar.gz

USER $USER

WORKDIR /home/$USER

ENTRYPOINT \
  ["/opt/conda/bin/python", "-u", "/usr/local/src/onhm-verify-eval/src/prms_verifier.py"]
