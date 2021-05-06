FROM nhmusgs/base

LABEL maintainer="ashalper@usgs.gov"

# out2ncf script
COPY --chown=nhm out2ncf /usr/local/bin

RUN chmod 744 /usr/local/bin/out2ncf

USER $USER

WORKDIR /home/$USER

ENTRYPOINT \
  ["/bin/bash", "-c", "/usr/local/bin/out2ncf"]
