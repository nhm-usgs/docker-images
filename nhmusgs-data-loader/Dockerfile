FROM nhmusgs/base:latest

LABEL maintainer="ashalper@usgs.gov"

COPY nhm /usr/local/bin

RUN chown $USER:$USER /usr/local/bin/nhm && \
  chmod 744 /usr/local/bin/nhm

USER $USER

WORKDIR /home/$USER

ENTRYPOINT ["/bin/bash", "-c", "/usr/local/bin/nhm"]
