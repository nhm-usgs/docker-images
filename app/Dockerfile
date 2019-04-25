FROM centos
RUN yum check-update; exit 0
RUN yum upgrade -y
RUN yum install centos-release-scl file gcc gcc-gfortran git make -y
RUN yum install rh-python36 -y
RUN cd /usr/local/src && git clone https://github.com/nhm-usgs/prms.git
RUN cd /usr/local/src/prms && make
CMD ["sleep", "infinity"]
