# using Miniconda 3 as the base image...
FROM continuumio/miniconda3:4.10.3p0

LABEL maintainer="ashalper@usgs.gov"

# install additional packages
RUN apt-get update && \
    apt-get -y install ca-certificates dialog file gcc gfortran libhdf5-mpich-dev \
	    libnetcdf-dev libnetcdff-dev make procps unzip && \
    apt-get autoclean && apt-get purge

# install DOI SSL intercept root certificate if reachable
RUN if wget http://sslhelp.doi.net/docs/DOIRootCA2.cer ; then \
        mkdir -p /usr/local/share/ca-certificates ; \
        mv DOIRootCA2.cer /usr/local/share/ca-certificates/DOIRootCA2.crt ; \
        update-ca-certificates ; \
    fi

# Update/upgrade Conda
RUN conda update -n base conda -y $insecure
RUN conda install -n base -c conda-forge $insecure \
    python=3.8 \
    dask=2021.4.1\
    bottleneck=1.3.2 \
    geopandas=0.9.0 \
    nco=4.9.8 \
    netcdf4=1.5.6 \
    pandas=1.2.4 \
    requests=2.25.1 \
    xarray=0.17.0 \
    xmltodict=0.12.0
RUN conda clean -a

ENV NHM_SOURCE_DIR=/usr/local/src

ARG VERSION_ONHM_RUNNERS=0.2.0

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
