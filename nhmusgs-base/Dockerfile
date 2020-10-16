# using Miniconda 3 as the base image...
FROM continuumio/miniconda3:4.7.12

LABEL maintainer="ashalper@usgs.gov"

# install additional packages
RUN apt-get update && \
    apt-get -y install dialog file gcc gfortran make procps unzip && \
    apt-get autoclean && apt-get purge

# It should only be necessary to set this to "-k" (the
# "conda update/install ..." option) at certain installations in
# .usgs.gov where the DOI root SSL certificate has not been installed
# (e.g., on a VM).
ARG insecure
RUN if [ "$insecure" = -k ]; then \
       wget http://sslhelp.doi.net/docs/DOIRootCA2.cer ; \
       # see
       # https://stackoverflow.com/questions/9072376/configure-git-to-accept-a-particular-self-signed-server-certificate-for-a-partic
       git config --global http.sslCAInfo DOIRootCA2.cer ; \
    fi

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

ARG VERSION_ONHM_RUNNERS=0.1.6

RUN git -c advice.detachedHead=false clone \
    https://github.com/nhm-usgs/onhm-runners.git \
    --branch $VERSION_ONHM_RUNNERS --depth=1 $NHM_SOURCE_DIR/onhm-runners && \
    cd $NHM_SOURCE_DIR/onhm-runners && \
    rm -rf .git && \
    rm .gitignore README.md .project .pydevproject

RUN mkdir -p /nhm/gridmetetl/Output

ENV USER=nhm
RUN useradd -ms /bin/bash $USER

RUN chown -R $USER /nhm
RUN chgrp -R $USER /nhm

ENV HOMEDIR=/home/$USER

VOLUME ["/nhm"]
