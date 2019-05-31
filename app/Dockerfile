# using Miniconda 3 as the base image...
FROM continuumio/miniconda3:latest
LABEL maintainer="ashalper@usgs.gov"
WORKDIR /root

# ...check for any Debian, installed packages updates
RUN apt-get update

# upgrade any CentOS installed packages updates
RUN apt-get -y upgrade

# install additional development packages
RUN apt-get -y install gcc gfortran git make procps unzip wget -y

# clone PRMS source
RUN cd /usr/local/src && \
    git clone https://github.com/nhm-usgs/prms.git

# build PRMS
RUN cd /usr/local/src/prms && make

# ...and remain running
CMD ["sleep", "infinity"]
