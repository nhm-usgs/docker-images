FROM nhmusgs/base

LABEL maintainer="ashalper@usgs.gov"

ARG VERSION_TAG_GRIDMETETL=v0.25

RUN wget -P $NHM_SOURCE_DIR https://github.com/nhm-usgs/gridmetetl/archive/$VERSION_TAG_GRIDMETETL.tar.gz
RUN cd $NHM_SOURCE_DIR && tar -xvzf $VERSION_TAG_GRIDMETETL.tar.gz
# not sure why it's necessary to omit the "v" from "0.25" here, but it is
RUN mv $NHM_SOURCE_DIR/gridmetetl-0.25 $NHM_SOURCE_DIR/gridmetetl
RUN rm $NHM_SOURCE_DIR/$VERSION_TAG_GRIDMETETL.tar.gz

USER $USER

WORKDIR $NHM_SOURCE_DIR

ENTRYPOINT \
  ["/opt/conda/bin/python", "-u", "/usr/local/src/gridmetetl/gridmetetl/Gridmet_current.py"]
