FROM nhmusgs/base

LABEL maintainer="ashalper@usgs.gov"

ARG VERSION_TAG_VERIFY=0.1.0

RUN git clone https://github.com/nhm-usgs/onhm-verify-eval.git --branch $VERSION_TAG_VERIFY --depth=1 $SOURCE_DIR/onhm-verify-eval && \
    cd $SOURCE_DIR/onhm-verify-eval && \
    rm -rf .git || true && \
    rm .gitignore || true && \
    rm Dockerfile || true

COPY --chown=nhm verifier /usr/local/bin

RUN chmod 744 /usr/local/bin/verifier

USER $USER

WORKDIR /home/$USER

RUN ln -s $SOURCE_DIR/onhm-verify-eval $HOMEDIR/onhm-verify-eval && \
    ln -s /var/lib/nhm $HOMEDIR/nhm

ENTRYPOINT ["/bin/bash", "-c", "/usr/local/bin/verifier"]
