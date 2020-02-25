FROM nhmusgs/base

LABEL maintainer="ashalper@usgs.gov"

COPY --chown=nhm out2ncf /usr/local/bin

RUN chmod 744 /usr/local/bin/out2ncf

USER $USER

WORKDIR /home/$USER

ENV NUMDAYS=60

ENTRYPOINT ["/usr/local/bin/out2ncf"]
