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

# create ofp shapefiles directory
RUN mkdir -p /var/lib/nhm/hru

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
