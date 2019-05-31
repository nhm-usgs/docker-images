# using Miniconda 3 as the base image...
FROM continuumio/miniconda3:latest
LABEL maintainer="ashalper@usgs.gov"
WORKDIR /root

# ...check for any Debian, installed packages updates
RUN apt-get update

# upgrade any CentOS installed packages updates
RUN apt-get -y upgrade

# install additional development packages
RUN apt-get install -y \
    automake \
    check \
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
    python3 \
    rake \
    ruby-minitest \
    rubygems \
    unzip \
    wget
# fUnit installs via gem
RUN gem install funit
      
# install custom .bashrc file
COPY .bashrc /root

# clone PRMS source
RUN cd /usr/local/src && \
    git clone -b 5.1.0 https://github.com/ashalper-usgs/prms.git
RUN cd /usr/local/src/prms && git pull

# Git repo. configuration
# TODO: make this an overridable default
RUN cd /usr/local/src/prms && \
	git config --global user.email ashalper@usgs.gov && \
	git config --global user.name "Andrew Halper"
RUN cd /usr/local/src/prms && \
	git config --global push.default simple

# Fortran unit testing tools
RUN wget -O /usr/local/src/fruit_3.4.3.zip \
    https://sourceforge.net/projects/fortranxunit/files/latest/download
RUN cd /usr/local/src && unzip fruit_3.4.3.zip
RUN rm -f /usr/local/src/fruit_3.4.3.zip
RUN cd /usr/local/src/fruit_3.4.3/fruit_processor_gem && \
  rake install

# "convenience" soft link
RUN ln -s /usr/local/src/prms /root/prms

# TODO: build PRMS; but first, in PRMS 5.x, we need to upgrade PRMS
#       Autotools' scripts:
#
# configure: error: in `/usr/local/src/prms/mmf':
# configure: error: The pkg-config script could not be found or is too
# old.  Make sure it is in your PATH or set the PKG_CONFIG environment
# variable to the full path to pkg-config.
#
# Alternatively, you may set the environment variables CHECK_CFLAGS
# and CHECK_LIBS to avoid the need to call pkg-config.  See the
# pkg-config man page for more details.
# 
# To get pkg-config, see <http://pkg-config.freedesktop.org/>.  See
# `config.log' for more details configure: error: ./configure failed
# for mmf

# ...and remain running
CMD ["sleep", "infinity"]
