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
RUN yum install -y \
    automake \
    centos-release-scl \
    check \
    check-devel \
    dos2unix \
    emacs-nox \
    file \
    gcc \
    gcc-c++ \
    gcc-gfortran \
    gdb \
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
# fUnit installs via gem
RUN gem install funit
      
# install custom .bashrc file
COPY .bashrc /root

# clone PRMS 6.x source
RUN cd /usr/local/src && \
    git clone https://code.usgs.gov/pnorton/prms6.git
RUN cd /usr/local/src/prms6 && git pull

# Git repo. configuration
# TODO: make this an overridable default
RUN cd /usr/local/src/prms6 && \
	git config --global user.email ashalper@usgs.gov && \
	git config --global user.name "Andrew Halper"
RUN cd /usr/local/src/prms6 && \
	git config --global push.default simple

# Fortran unit testing tools
RUN wget -O /usr/local/src/fruit_3.4.3.zip \
    https://sourceforge.net/projects/fortranxunit/files/latest/download
RUN cd /usr/local/src && unzip fruit_3.4.3.zip
RUN rm -f /usr/local/src/fruit_3.4.3.zip
RUN cd /usr/local/src/fruit_3.4.3/fruit_processor_gem && \
  rake install

# "convenience" soft link
RUN ln -s /usr/local/src/prms6 /root/prms

# build PRMS
RUN cd /usr/local/src/prms6 && make

# ...and remain running
CMD ["sleep", "infinity"]
