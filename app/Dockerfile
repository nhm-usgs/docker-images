# using CentOS as the base image...
FROM centos

LABEL maintainer="ashalper@usgs.gov"

# ...check for any CentOS installed packages updates; exit cleanly for
# the benefit of Docker
RUN yum check-update; exit 0

# upgrade any CentOS installed packages updates
RUN yum upgrade -y

# install additional development packages
RUN yum install -y \
    centos-release-scl \
    dos2unix \
    emacs-nox \
    file \
    gcc \
    gcc-c++ \
    gcc-gfortran \
    git \
    graphviz \
    make \
    python3 \
    rh-python35-python-pip \
    rubygem-minitest \
    rubygem-rake \
    rubygems \
    unzip \
    wget \
    which
RUN gem install funit
      
# install custom .bashrc file
COPY .bashrc /root

# clone PRMS 5.x source
RUN cd /usr/local/src && \
    git clone -b 5.0.0_rc https://github.com/nhm-usgs/prms.git

# Fortran unit testing tools
RUN wget -O /usr/local/src/fruit_3.4.3.zip \
    https://sourceforge.net/projects/fortranxunit/files/latest/download
RUN cd /usr/local/src && unzip fruit_3.4.3.zip
RUN rm -f /usr/local/src/fruit_3.4.3.zip
RUN cd /usr/local/src/fruit_3.4.3/fruit_processor_gem && \
  rake install

# "convenience" soft link
RUN ln -s /usr/local/src/prms /root/prms

# ...and remain running
CMD ["sleep", "infinity"]
