FROM nhmusgs/base

LABEL maintainer="ashalper@usgs.gov"

COPY --chown=nhm ncf2cbh /usr/local/bin

RUN chmod 744 /usr/local/bin/ncf2cbh

USER $USER

WORKDIR /home/$USER

ENV NUMDAYS=60

ENTRYPOINT ["/usr/local/bin/ncf2cbh"]
