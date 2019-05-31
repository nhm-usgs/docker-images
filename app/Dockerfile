# using Minimal Jupyter Notebook Stack...
FROM jupyter/minimal-notebook:latest
LABEL maintainer="ashalper@usgs.gov"
USER root

# ...check for any Debian, installed packages updates
RUN apt-get update

# upgrade any Debian, installed packages updates
RUN apt-get -y upgrade

# install GFortran
RUN apt-get -y install gfortran

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
