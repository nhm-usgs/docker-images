# using Miniconda 3 as the base image...
FROM continuumio/miniconda3:latest
LABEL maintainer="ashalper@usgs.gov"
WORKDIR /root

# ...check for any Debian, installed packages updates
RUN apt-get update

# upgrade any Debian, installed packages updates
RUN apt-get -y upgrade

# install additional development packages
RUN apt-get install -y \
    automake \
    check \
    dialog \
    dos2unix \
    emacs-nox \
    file \
    g++-6 \
    gcc \
    gdb \
    gfortran \
    git \
    graphviz \
    make \
    procps \
    python3 \
    rake \
    ruby-minitest \
    rubygems \
    unzip \
    wget

# install custom .bashrc file
COPY .bashrc /root

# create the Conda environment
RUN wget -P /root \
    https://raw.githubusercontent.com/nhm-usgs/ofp-docker/master/app/environment.yml
RUN conda update -n base conda -y && conda env update
RUN rm -f /root/environment.yml

# create NHM directories under /var/lib
RUN mkdir -p /var/lib/nhm/ofp/Data
RUN mkdir -p /var/lib/nhm/ofp/Output

# clone ofp source
RUN cd /usr/local/src && git clone -b ashalper --depth=1 \
    https://github.com/ashalper-usgs/onhm-fetcher-parser.git

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
# fUnit installs via gem
RUN gem install funit

# "convenience" soft links
RUN ln -s /usr/local/src/prms6 /root/prms
RUN ln -s /usr/local/src/onhm-fetcher-parser /root/onhm-fetcher-parser

# build PRMS
RUN cd /usr/local/src/prms6 && make

# ...and remain running
CMD ["sleep", "infinity"]
