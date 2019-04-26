# using CentOS as the base image...
FROM centos

# ...check for any CentOS installed packages updates (while ignoring
# errors/warnings; exit cleanly for the sake of Docker);
RUN yum check-update; exit 0

# upgrade any CentOS installed packages updates;
RUN yum upgrade -y

# install Python 3 repo. references, Emacs, file, GCC, GFortran, Git,
# Make, and which;
RUN yum install centos-release-scl emacs-nox file gcc gcc-gfortran git make which -y

# install Python 3;
RUN yum install rh-python36 -y

# clone PRMS source;
RUN cd /usr/local/src && git clone https://github.com/nhm-usgs/prms.git

# build PRMS;
RUN cd /usr/local/src/prms && make

# and remain running
CMD ["sleep", "infinity"]
