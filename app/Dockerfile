# using CentOS as the base image...
FROM centos

# ...check for any CentOS installed packages updates (while ignoring
# errors/warnings; exit cleanly for the sake of Docker)
RUN yum check-update; exit 0

# upgrade any CentOS installed packages updates
RUN yum upgrade -y

# install additional development packages
RUN yum install centos-release-scl dos2unix emacs-nox file gcc gcc-c++ gcc-gfortran git make rubygem-minitest rubygem-rake rubygems unzip which wget -y

# install fUnit
RUN gem install funit

# install FRUIT
RUN wget -O /usr/local/src/fruit_3.4.3.zip https://sourceforge.net/projects/fortranxunit/files/latest/download
RUN cd /usr/local/src && unzip fruit_3.4.3.zip
RUN rm -f /usr/local/src/fruit_3.4.3.zip
RUN cd /usr/local/src/fruit_3.4.3/fruit_processor_gem && rake install

# install Python 3
RUN yum install rh-python36 -y

# clone PRMS source
RUN cd /usr/local/src && git clone https://github.com/nhm-usgs/prms.git

# build PRMS
RUN cd /usr/local/src/prms && make

# and remain running
CMD ["sleep", "infinity"]
