FROM nhmusgs/base

LABEL maintainer="ashalper@usgs.gov"

# Build PRMS
RUN git clone https://github.com/nhm-usgs/prms.git --branch 5.0.0 --depth=1 $SOURCE_DIR/prms && \
    cd $SOURCE_DIR/prms && \
    make && \
    rm -rf .git || true && \
    rm .gitignore || true && \
    rm Makefile || true && \
    rm makelist || true

COPY --chown=nhm nhm-prms /usr/local/bin

RUN chmod 744 /usr/local/bin/nhm-prms && \
    chown -R $USER $SOURCE_DIR/prms 

USER $USER

WORKDIR /home/$USER

RUN ln -s $SOURCE_DIR/prms $HOMEDIR/prms && \
    ln -s /var/lib/nhm $HOMEDIR/nhm

ENTRYPOINT ["/bin/bash", "-c", "/usr/local/bin/nhm-prms"]