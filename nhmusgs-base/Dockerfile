# using Miniconda 3 as the base image...
FROM continuumio/miniconda3:4.7.12

LABEL maintainer="ashalper@usgs.gov"

# install additional packages
RUN apt-get update && \
    apt-get -y install dialog file gcc gfortran make procps unzip && \
    apt-get autoclean && apt-get purge

# Update/upgrade Conda
RUN conda update -n base conda -y && \
    conda install -n base -c defaults -c conda-forge \
    rasterstats=0.13.1 \
    jupyter=1.0.0 \
    notebook=6.0.1 \
    cartopy=0.17.0 \
    python=3.7 \
    matplotlib=3.1.1 \
    rasterio=1.0.21 \
    cipy=1.3.1 \
    docker-py=4.0.2 \
    xarray=0.13.0 \
    geopandas=0.4.1 \
    xmltodict=0.12.0 \
    numpy=1.17.2 \
    dask=2.6.0 \
    netcdf4=1.4.2 \
    bottleneck=1.2.1 \
    pandas=0.25.2 && \
    conda clean -a

ENV SOURCE_DIR=/usr/local/src

ARG VERSION_ONHM_RUNNERS=0.1.4

RUN git clone https://github.com/nhm-usgs/onhm-runners.git --branch $VERSION_ONHM_RUNNERS --depth=1 $SOURCE_DIR/onhm-runners && \
    cd $SOURCE_DIR/onhm-runners && \
    rm -rf .git && \
    rm .gitignore README.md .project .pydevproject

RUN mkdir -p /var/lib/nhm/ofp/Output

ENV USER=nhm

RUN useradd -ms /bin/bash $USER

RUN chown -R $USER /var/lib/nhm
RUN chgrp -R $USER /var/lib/nhm

# shell functions used by more than one entry-point script
RUN mkdir -p /usr/local/share/nhm
COPY nhm.sh /usr/local/share/nhm
RUN chown -R $USER /usr/local/share/nhm
RUN chmod 744 /usr/local/share/nhm/nhm.sh

ENV HOMEDIR=/home/$USER

VOLUME ["/var/lib/nhm"]
