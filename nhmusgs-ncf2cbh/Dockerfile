FROM nhmusgs/base:latest

LABEL maintainer="ashalper@usgs.gov"

COPY ncf2cbh /usr/local/bin

RUN chown $USER:$USER /usr/local/bin/ncf2cbh && \
  chmod 744 /usr/local/bin/ncf2cbh

USER $USER

WORKDIR /home/$USER

ENTRYPOINT ["/bin/bash", "-c", "/usr/local/bin/ncf2cbh"]
