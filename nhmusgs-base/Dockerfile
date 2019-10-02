FROM continuumio/miniconda3:4.7.10

LABEL maintainer="ashalper@usgs.gov"

# Update debian repository cache, install additional packages
RUN apt-get update && \
    apt-get -y install dialog file gcc gfortran make procps unzip && \
    apt-get autoclean && apt-get purge

# Update/upgrade Conda
RUN conda update -n base conda -y && \
  conda install -n base -c defaults -c conda-forge \
  python=3.6 \
  bottleneck \
  cartopy \
  dask \
  geopandas \
  jupyter \
  matplotlib \
  netcdf4 \
  notebook=5.7.4 \
  numpy \
  pandas \
  rasterio \
  rasterstats \
  scipy \
  xarray \
  xmltodict && \
  conda clean -a

ENV SOURCE_DIR=/usr/local/src

ARG VERSION_ONHM_RUNNERS=0.1.3

RUN git clone https://github.com/nhm-usgs/onhm-runners.git --branch $VERSION_ONHM_RUNNERS --depth=1 $SOURCE_DIR/onhm-runners && \
    cd $SOURCE_DIR/onhm-runners && \
    rm -rf .git || true && \
    rm .gitignore || true

RUN mkdir -p /var/lib/nhm/ofp/Output

ENV USER=nhm

RUN useradd -ms /bin/bash $USER

VOLUME ["/var/lib/nhm"]

RUN chown -R $USER:$USER /var/lib/nhm

# shell functions used by more than one entry-point script
RUN mkdir -p /usr/local/share/nhm
COPY nhm.sh /usr/local/share/nhm
RUN chown -R $USER:$USER /usr/local/share/nhm
RUN chmod 744 /usr/local/share/nhm/nhm.sh

ENV HOMEDIR=/home/$USER
