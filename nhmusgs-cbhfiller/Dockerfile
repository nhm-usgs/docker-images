FROM nhmusgs/base:1.0

LABEL maintainer="ashalper@usgs.gov"

COPY --chown=nhm cbhfiller /usr/local/bin

RUN chmod 744 /usr/local/bin/cbhfiller

USER $USER

WORKDIR /home/$USER

ENTRYPOINT ["/bin/bash", "-c", "/usr/local/bin/cbhfiller"]
