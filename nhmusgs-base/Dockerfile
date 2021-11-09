# using Miniconda 3 as the base image...
FROM continuumio/miniconda3:4.10.3p0

LABEL maintainer="ashalper@usgs.gov"

# install additional packages
RUN apt-get update && \
    apt-get -y install dialog file gcc gfortran libhdf5-mpich-dev \
	    libnetcdf-dev libnetcdff-dev make procps unzip && \
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
# ARG VERSION_ONHM_RUNNERS=master

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
