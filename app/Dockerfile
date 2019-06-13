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

# create ofp directory under /var/lib
RUN mkdir -p /var/lib/nhm/ofp/Output

# clone ofp source
RUN pwd
RUN printenv
RUN cd /usr/local/src && git clone --depth=1 \
    https://github.com/nhm-usgs/onhm-fetcher-parser.git

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
# fUnit installs via gem
RUN gem install funit

# "convenience" soft links
RUN ln -s /usr/local/src/prms /root/prms
RUN ln -s /usr/local/src/onhm-fetcher-parser /root/onhm-fetcher-parser

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

# onhm-runners source
RUN cd /usr/local/src && \
    git clone -b develop https://github.com/ashalper-usgs/onhm-runners.git

# onhm-verify-eval source
RUN cd /usr/local/src && \
    git clone https://github.com/nhm-usgs/onhm-verify-eval.git

# convenience soft-links
RUN ln -s /usr/local/src/onhm-fetcher-parser /root/onhm-fetcher-parser
RUN ln -s /usr/local/src/prms /root/prms
RUN ln -s /usr/local/src/onhm-runners /root/onhm-runners
RUN ln -s /usr/local/src/onhm-verify-eval /root/onhm-verify-eval
RUN ln -s /var/lib/nhm /root/nhm

# entrypoint scripts
ADD ofp-entrypoint /usr/local/bin
ADD prms-entrypoint /usr/local/bin
RUN cd /usr/local/bin && chmod 744 ofp-entrypoint prms-entrypoint

# ...and remain running
CMD ["sleep", "infinity"]
