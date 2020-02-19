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
      python=3.6 \
      bottleneck=1.2.1 \
      cartopy=0.17.0 \
      dask=2.6.0 \
      geopandas=0.4.1 \
      jupyter=1.0.0 \
      matplotlib=3.1.1 \
      netcdf4=1.4.2 \
      notebook=5.7.4 \
      numpy=1.17.2 \
      pandas=0.25.2 \
      rasterio=1.0.21 \
      rasterstats=0.13.1 \
      scipy=1.3.1 \
      xarray=0.13.0 \
      xmltodict=0.12.0 && \
    conda clean -a

ENV SOURCE_DIR=/usr/local/src

# see
# https://stackoverflow.com/questions/9072376/configure-git-to-accept-a-particular-self-signed-server-certificate-for-a-partic
RUN if false; then \
       wget http://sslhelp.doi.net/docs/DOIRootCA2.cer && \
       git config --global http.sslCAInfo DOIRootCA2.cer ; \
    fi

RUN git -c advice.detachedHead=false clone \
    https://github.com/nhm-usgs/onhm-runners.git \
    --branch master --depth=1 $SOURCE_DIR/onhm-runners && \
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
