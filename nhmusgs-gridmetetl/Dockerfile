FROM nhmusgs/base:1.1

LABEL maintainer="ashalper@usgs.gov"

COPY --chown=nhm gridmetetl /usr/local/bin
RUN chmod 744 /usr/local/bin/gridmetetl

USER $USER

WORKDIR /home/$USER

ENTRYPOINT ["/bin/bash", "-c", "/usr/local/bin/gridmetetl"]
