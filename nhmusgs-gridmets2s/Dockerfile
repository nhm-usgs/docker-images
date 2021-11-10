# using Miniconda 3 as the base image...
FROM nhmusgs/base

LABEL maintainer="rmcd@usgs.gov"

# download and install gridmetetl_s2s
ARG VERSION_GRIDMETETL_S2S=0.2.1
RUN pip --trusted-host pypi.org --trusted-host files.pythonhosted.org install git+https://github.com/nhm-usgs/gridmet_cfsv2.git@$VERSION_GRIDMETETL_S2S#egg=gridmet_cfsv2

# download and install grid2shp
ARG VERSION_GRD2SHP=0.3.0
RUN pip --trusted-host pypi.org --trusted-host files.pythonhosted.org install git+https://github.com/nhm-usgs/grd2shp.git@$VERSION_GRD2SHP#egg=grd2shp

COPY --chown=nhm gmetl_cfsv2 /usr/local/bin
RUN chmod 744 /usr/local/bin/gmetl_cfsv2

COPY --chown=nhm rungmetl_cfs.py /usr/local/bin
RUN chmod 744 /usr/local/bin/rungmetl_cfs.py

USER $USER

WORKDIR /home/$USER

ENTRYPOINT ["/bin/bash", "-c", "/usr/local/bin/gmetl_cfsv2"]
