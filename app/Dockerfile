# using Miniconda 3 as the base image...
FROM continuumio/miniconda3:latest
LABEL maintainer="ashalper@usgs.gov"
WORKDIR /root

# ...check for any Debian, installed packages updates
RUN apt-get update

# upgrade any Debian, installed packages updates
RUN apt-get -y upgrade

# install additional packages
RUN apt-get -y install dialog file gcc gfortran git make procps unzip wget vim

# create the Conda environment
RUN wget -P /root \
    https://raw.githubusercontent.com/nhm-usgs/ofp-docker/master/app/environment.yml
RUN conda update -n base conda -y && conda env update
RUN rm -f /root/environment.yml

# create ofp directory under /var/lib
RUN mkdir -p /var/lib/nhm/ofp/Output

# clone ofp source
RUN printenv
RUN cd /usr/local/src && git clone --depth=1 \
    https://github.com/nhm-usgs/onhm-fetcher-parser.git

# clone PRMS source
RUN cd /usr/local/src && \
    git clone https://github.com/nhm-usgs/prms.git

# build PRMS
RUN cd /usr/local/src/prms && make

# onhm-runners source
RUN pwd
RUN cd /usr/local/src && \
    git clone -b master https://github.com/nhm-usgs/onhm-runners.git

# onhm-verify-eval source
RUN cd /usr/local/src && \
    git clone https://github.com/nhm-usgs/onhm-verify-eval.git

# convenience soft-links
RUN ln -s /usr/local/src/onhm-fetcher-parser /root/onhm-fetcher-parser
RUN ln -s /usr/local/src/prms /root/prms
RUN ln -s /usr/local/src/onhm-runners /root/onhm-runners
RUN ln -s /usr/local/src/onhm-verify-eval /root/onhm-verify-eval
RUN ln -s /var/lib/nhm /root/nhm

# ofp script
ADD ofp /usr/local/bin
RUN chmod 744 /usr/local/bin/ofp

#cdf2cbh script
ADD cdf2cbh /usr/local/bin
RUN chmod 744 /usr/local/bin/cdf2cbh

# controller script
RUN pwd
ADD nhm /usr/local/bin
RUN chmod 744 /usr/local/bin/nhm

# ...and remain running
CMD ["sleep", "infinity"]
