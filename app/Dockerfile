FROM centos
RUN yum check-update; exit 0
RUN yum upgrade -y
RUN yum install file gcc gcc-gfortran git make -y
RUN cd /usr/local/src && git clone https://github.com/nhm-usgs/prms.git
RUN cd /usr/local/src/prms && make
CMD ["sleep", "infinity"]
