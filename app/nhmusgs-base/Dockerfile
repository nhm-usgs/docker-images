# using Miniconda 3 as the base image...
FROM continuumio/miniconda3:latest

LABEL maintainer="ashalper@usgs.gov"

# ...check for any Debian, installed packages updates, upgrade them and install
# additional packages
RUN apt-get update && apt-get -y upgrade && \
    apt-get -y install dialog file gcc gfortran make procps unzip && \
    apt-get autoclean && apt-get purge

# Update Conda
RUN wget https://raw.githubusercontent.com/nhm-usgs/ofp-docker/master/app/environment.yml && \
    conda update -n base conda -y && conda env update && conda clean -a && \
    rm -f environment.yml

ENV SOURCE_DIR=/usr/local/src

RUN git clone https://github.com/nhm-usgs/onhm-runners.git --branch 0.1.1 --depth=1 $SOURCE_DIR/onhm-runners && \
    cd $SOURCE_DIR/onhm-runners && \
    rm -rf .git || true && \
    rm .gitignore || true

RUN mkdir -p /var/lib/nhm/ofp/Output

ENV USER=nhm

RUN useradd -ms /bin/bash $USER

RUN chown -R $USER /var/lib/nhm

ENV HOMEDIR=/home/$USER

VOLUME ["/var/lib/nhm"]
