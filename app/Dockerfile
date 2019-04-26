# using CentOS as the base image...
FROM centos

# ...check for any CentOS installed packages updates (while ignoring unreachable HTTP errors; exit cleanly);
RUN yum check-update; exit 0

# upgrade any CentOS installed packages updates;
RUN yum upgrade -y > /dev/null 2>&1; exit 0

# install Python 3 repo., file, GCC, GFortran, Git, and Make;
RUN yum install centos-release-scl file gcc gcc-gfortran git make -y > /dev/null 2>&1; exit 0

# install Python 3;
RUN yum install rh-python36 -y > /dev/null 2>&1; exit 0

# clone PRMS source;
RUN cd /usr/local/src && git clone https://github.com/nhm-usgs/prms.git

# build PRMS;
RUN cd /usr/local/src/prms && make

# and remain running
CMD ["sleep", "infinity"]
