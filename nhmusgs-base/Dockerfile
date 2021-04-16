# using Miniconda 3 as the base image...
FROM continuumio/miniconda3:4.7.12

LABEL maintainer="ashalper@usgs.gov"

# TODO: See
# https://blog.ronnyvdb.net/2019/09/02/howto-install-self-signed-ca-root-certificate-on-linux/
# and
# https://unix.stackexchange.com/questions/96215/feeding-input-values-to-dpkg-reconfigure-in-a-non-interactive-way
# for how to use DOI SSL intercept certificate properly.

# install additional packages
RUN apt-get update && \
    apt-get -y install dialog file gcc gfortran make procps unzip && \
    apt-get autoclean && apt-get purge

# Update/upgrade Conda
RUN conda update -n base conda -y -k
RUN conda install -n base -c defaults -c conda-forge -k \
    python=3.7 \
    dask \
    geopandas \
    nco \
    netcdf4 \
    pandas\
    requests \
    xarray \
    xmltodict
RUN conda clean -a

ENV NHM_SOURCE_DIR=/usr/local/src

ARG VERSION_ONHM_RUNNERS=0.1.7
RUN wget --no-check-certificate -P $NHM_SOURCE_DIR -nv \
  https://github.com/nhm-usgs/onhm-runners/archive/$VERSION_ONHM_RUNNERS.tar.gz
RUN cd $NHM_SOURCE_DIR && tar -xzf $VERSION_ONHM_RUNNERS.tar.gz
RUN mv $NHM_SOURCE_DIR/onhm-runners-$VERSION_ONHM_RUNNERS \
    $NHM_SOURCE_DIR/onhm-runners
RUN rm $NHM_SOURCE_DIR/$VERSION_ONHM_RUNNERS.tar.gz

ARG VERSION_TAG_GRIDMETETL=0.29
RUN wget --no-check-certificate -P $NHM_SOURCE_DIR -nv \
  https://github.com/nhm-usgs/gridmetetl/archive/$VERSION_TAG_GRIDMETETL.tar.gz
RUN cd $NHM_SOURCE_DIR && tar -xvzf $VERSION_TAG_GRIDMETETL.tar.gz
# not sure why it's necessary to omit the "v" from "0.25" here, but it is
RUN mv $NHM_SOURCE_DIR/gridmetetl-$VERSION_TAG_GRIDMETETL $NHM_SOURCE_DIR/gridmetetl
RUN rm $NHM_SOURCE_DIR/$VERSION_TAG_GRIDMETETL.tar.gz

ENV USER=nhm
RUN useradd -ms /bin/bash $USER

RUN mkdir /nhm
RUN chown -R $USER /nhm
RUN chgrp -R $USER /nhm

ENV HOMEDIR=/home/$USER

VOLUME ["/nhm"]
