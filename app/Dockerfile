# using CentOS as the base image...
FROM centos
LABEL maintainer="ashalper@usgs.gov"
WORKDIR /root

# ...check for any CentOS installed packages updates; exit cleanly for
# the benefit of Docker
RUN yum check-update; exit 0

# upgrade any CentOS installed packages updates
RUN yum upgrade -y

# install additional development packages
RUN yum install centos-release-scl gcc gcc-gfortran git make unzip \
    which wget -y

# clone PRMS source
RUN cd /usr/local/src && \
    git clone https://github.com/nhm-usgs/prms.git

# build PRMS
RUN cd /usr/local/src/prms && make

# ...and remain running
CMD ["sleep", "infinity"]
