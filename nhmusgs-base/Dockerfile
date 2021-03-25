# using Miniconda 3 as the base image...
FROM continuumio/miniconda3:4.7.12

LABEL maintainer="ashalper@usgs.gov"

# install additional packages
RUN apt-get update && \
    apt-get -y install dialog file gcc gfortran make procps unzip && \
    apt-get autoclean && apt-get purge

# Check where we are, to see if we need to do additional work to cope
# with the DOI SSL intercept. See also
# https://github.com/usgs/best-practices/blob/master/ssl/WorkingWithinSSLIntercept.md
ARG doi=`nslookup `hostname` | awk '/^Name:/ { print match($2, "(.usgs.gov|.doi.net)$") }'`
RUN if [ "$doi" != 0 ]; then \
       wget -nv http://sslhelp.doi.net/docs/DOIRootCA2.cer ; \
       # see
       # https://stackoverflow.com/questions/9072376/configure-git-to-accept-a-particular-self-signed-server-certificate-for-a-partic
       git config --global http.sslCAInfo DOIRootCA2.cer ; \
    fi

# either we're outside DOI, or we go with "-k" option to Conda
#`( test $doi = 0 || echo '-k' )`
ARG insecure='-k'

# Update/upgrade Conda
RUN conda update -n base conda -y $insecure
RUN conda install -n base -c defaults -c conda-forge $insecure \
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

# TODO: change --no-check-certificate to --certificate=DOIRootCA2.cer
# here once we figure out how to do that
ARG certificate='--no-check-certificate'

ARG VERSION_ONHM_RUNNERS=0.1.7
RUN wget $certificate -P $NHM_SOURCE_DIR -nv \
  https://github.com/nhm-usgs/onhm-runners/archive/$VERSION_ONHM_RUNNERS.tar.gz
RUN cd $NHM_SOURCE_DIR && tar -xzf $VERSION_ONHM_RUNNERS.tar.gz
RUN mv $NHM_SOURCE_DIR/onhm-runners-$VERSION_ONHM_RUNNERS \
    $NHM_SOURCE_DIR/onhm-runners
RUN rm $NHM_SOURCE_DIR/$VERSION_ONHM_RUNNERS.tar.gz

ARG VERSION_TAG_GRIDMETETL=0.29
RUN wget $certificate -P $NHM_SOURCE_DIR -nv \
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
