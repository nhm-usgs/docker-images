FROM nhmusgs/base:1.0

LABEL maintainer="ashalper@usgs.gov"


# ofp script
COPY --chown=nhm ncf2cbh /usr/local/bin

RUN chmod 744 /usr/local/bin/ncf2cbh

USER $USER

WORKDIR /home/$USER

ENTRYPOINT \
  ["/bin/bash", "-c", "/usr/local/bin/ncf2cbh"]
