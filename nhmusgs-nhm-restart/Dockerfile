FROM nhmusgs/base

LABEL maintainer="ashalper@usgs.gov"

ARG VERSION_TAG_PRMS=5.0.0

COPY --chown=nhm nhm-restart /usr/local/bin
RUN chmod 744 /usr/local/bin/nhm-restart

USER $USER

WORKDIR /home/$USER

ENTRYPOINT ["/bin/bash", "-c", "/usr/local/bin/nhm-restart"]
