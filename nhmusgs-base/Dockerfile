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

ARG VERSION_ONHM_RUNNERS=0.1.1

RUN git clone https://github.com/nhm-usgs/onhm-runners.git --branch $VERSION_ONHM_RUNNERS --depth=1 $SOURCE_DIR/onhm-runners && \
    cd $SOURCE_DIR/onhm-runners && \
    rm -rf .git || true && \
    rm .gitignore || true

# shell functions used by more than one entry-point script
RUN mkdir -p /usr/local/share/nhm
COPY --chown=nhm nhm.sh /usr/local/share/nhm
RUN chmod 744 /usr/local/share/nhm/nhm.sh

RUN mkdir -p /var/lib/nhm/ofp/Output

ENV USER=nhm

RUN useradd -ms /bin/bash $USER

RUN chown -R $USER /var/lib/nhm

ENV HOMEDIR=/home/$USER

VOLUME ["/var/lib/nhm"]
