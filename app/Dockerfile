# using Miniconda 3 as the base image...
FROM continuumio/miniconda3:latest
LABEL maintainer="ashalper@usgs.gov"
WORKDIR /root

# ...check for any Debian, installed packages updates
RUN apt-get update

# upgrade any Debian, installed packages updates
RUN apt-get -y upgrade

# install additional packages
RUN apt-get -y install dialog gcc gfortran git make procps unzip wget

# TODO: skip next two steps if shapefiles are already present

# create data directory
RUN mkdir -p /var/lib/nhm/hru
# download shapefiles
RUN wget -P /var/lib/nhm/hru -m -nH --cut-dirs=5 --user='anonymous' \
       ftp://ftpext.usgs.gov/pub/cr/co/lakewood/nhm_hru_shp

# clone PRMS source
RUN cd /usr/local/src && \
    git clone https://github.com/nhm-usgs/prms.git

# build PRMS
RUN cd /usr/local/src/prms && make

# clone onhm-runners source
RUN cd /usr/local/src && \
    git clone -b develop https://github.com/nhm-usgs/onhm-runners.git

# ...and remain running
CMD ["sleep", "infinity"]
