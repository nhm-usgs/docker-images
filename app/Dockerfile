# using CentOS as the base image...
FROM centos

LABEL maintainer="ashalper@usgs.gov"

# Domain: {stable,testing,unstable}; defaults to "stable" below. Run
# like: 'docker-compose build --build-arg arg=stable' to set.
ARG release

# ...check for any CentOS installed packages updates; exit cleanly for
# the benefit of Docker
RUN yum check-update; exit 0

# upgrade any CentOS installed packages updates
RUN yum upgrade -y

# install additional development packages
RUN yum install centos-release-scl gcc gcc-gfortran git make unzip \
    which wget -y

# if release not specified, default to "stable"
RUN if [ "x$release" = "x" ] ; then \
      export release=stable ; \
    fi

# if "unstable" release, install additional development packages and
# prerequisites
RUN if [ "x$release" = "xunstable" ] ; then \
      yum install dos2unix emacs-nox file gcc-c++ graphviz python3 \
	  rh-python35-python-pip rubygem-minitest rubygem-rake \
	  rubygems -y ; \
      gem install funit ; \
            wget -O /usr/local/src/fruit_3.4.3.zip \
	https://sourceforge.net/projects/fortranxunit/files/latest/download ; \
      cd /usr/local/src && unzip fruit_3.4.3.zip ; \
      rm -f /usr/local/src/fruit_3.4.3.zip ; \
      cd /usr/local/src/fruit_3.4.3/fruit_processor_gem && \
	  rake install ; \
      printf '\n# gprof2dot installs in a weird location\n\
export PATH="/opt/rh/rh-python35/root/usr/bin:$PATH"\n' >> \
	  /root/.bashrc ; \
fi

# clone PRMS source
RUN cd /usr/local/src && \
    git clone https://github.com/nhm-usgs/prms.git

# build PRMS
RUN cd /usr/local/src/prms && make

# ...and remain running
CMD ["sleep", "infinity"]
