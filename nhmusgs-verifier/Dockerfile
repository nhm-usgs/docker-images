FROM nhmusgs/base:latest

LABEL maintainer="ashalper@usgs.gov"

ARG VERSION_TAG_VERIFY=0.1.1

RUN git clone https://github.com/nhm-usgs/onhm-verify-eval.git --branch $VERSION_TAG_VERIFY --depth=1 $SOURCE_DIR/onhm-verify-eval && \
    cd $SOURCE_DIR/onhm-verify-eval && \
    rm -rf .git || true && \
    rm .gitignore || true && \
    rm Dockerfile || true

COPY verifier /usr/local/bin

RUN chown $USER:$USER /usr/local/bin/verifier && \
  chmod 744 /usr/local/bin/verifier

USER $USER

WORKDIR /home/$USER

ENTRYPOINT ["/bin/bash", "-c", "/usr/local/bin/verifier"]
