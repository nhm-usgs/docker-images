FROM nhmusgs/base

LABEL maintainer="ashalper@usgs.gov"

ARG VERSION_TAG_VERIFY=0.1.1

RUN git clone https://github.com/nhm-usgs/onhm-verify-eval.git --branch $VERSION_TAG_VERIFY --depth=1 $SOURCE_DIR/onhm-verify-eval -c http.sslVerify=false && \
    cd $SOURCE_DIR/onhm-verify-eval && \
    rm -rf .git || true && \
    rm .gitignore || true && \
    rm Dockerfile || true

USER $USER

WORKDIR /home/$USER

ENTRYPOINT \
  ["/opt/conda/bin/python", "-u", "/usr/local/src/onhm-verify-eval/src/prms_verifier.py"]
