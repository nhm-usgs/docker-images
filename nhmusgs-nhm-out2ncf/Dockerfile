FROM nhmusgs/base:latest

LABEL maintainer="ashalper@usgs.gov"

COPY out2ncf /usr/local/bin

RUN chown $USER:$USER /usr/local/bin/out2ncf && \
  chmod 744 /usr/local/bin/out2ncf

USER $USER

WORKDIR /home/$USER

ENTRYPOINT ["/bin/bash", "-c", "/usr/local/bin/out2ncf"]
