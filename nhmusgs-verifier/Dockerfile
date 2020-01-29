FROM nhmusgs/base

LABEL maintainer="ashalper@usgs.gov"

ARG VERSION_TAG_VERIFY=0.1.1

COPY --chown=nhm verifier /usr/local/bin

RUN chmod 744 /usr/local/bin/verifier

RUN git -c advice.detachedHead=false clone https://github.com/nhm-usgs/onhm-verify-eval.git --branch $VERSION_TAG_VERIFY --depth=1 $SOURCE_DIR/onhm-verify-eval && \
    cd $SOURCE_DIR/onhm-verify-eval && \
    rm -rf .git || true && \
    rm .gitignore || true && \
    rm Dockerfile || true

USER $USER

WORKDIR /home/$USER

ENTRYPOINT ["/bin/bash", "-c", "/usr/local/bin/verifier"]
