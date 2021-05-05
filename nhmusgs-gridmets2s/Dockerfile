# using Miniconda 3 as the base image...
FROM nhmusgs/base

LABEL maintainer="rmcd@usgs.gov"

# install additional packages
# RUN apt-get update && \
#     apt-get -y install dialog file make unzip ca-certificates libspatialindex-dev && \
#     apt-get autoclean && apt-get purge

# # It should only be necessary to set this to "-k" (the
# # "conda update/install ..." option) at certain installations in
# # .usgs.gov where the DOI root SSL certificate has not been installed
# # (e.g., on a VM).
# ARG insecure
# RUN if [ "$insecure" = -k ]; then \
#        wget http://sslhelp.doi.net/docs/DOIRootCA2.cer ; \
#        # see
#        # https://stackoverflow.com/questions/9072376/configure-git-to-accept-a-particular-self-signed-server-certificate-for-a-partic
#        git config --global http.sslCAInfo DOIRootCA2.cer ; \
#     fi

# Update/upgrade Conda
# RUN conda update -n base conda -y $insecure
# RUN conda install -n base -c conda-forge $insecure \
#       python=3.8 \
#       dask \
#       bottleneck \
#       pandas \
#       geopandas \
#       xarray \
#       netcdf4 \
#       metpy

# RUN conda clean -a

# ENV NHM_SOURCE_DIR=/usr/local/src

# download and install gridmetetl_s2s
ARG VERSION_GRIDMETETL_S2S=0.2.0
RUN pip --trusted-host pypi.org --trusted-host files.pythonhosted.org install git+https://github.com/rmcd-mscb/gridmet_cfsv2.git@$VERSION_GRIDMETETL_S2S#egg=gridmet_cfsv2

#download and install grid2shp
ARG VERSION_GRD2SHP=0.2.3
# RUN pip --trusted-host pypi.org --trusted-host files.pythonhosted.org install git+https://github.com/nhm-usgs/grd2shp.git@$VERSION_GRD2SHP#egg=grd2shp
RUN pip --trusted-host pypi.org --trusted-host files.pythonhosted.org install git+https://github.com/nhm-usgs/grd2shp.git@datetag


COPY --chown=nhm gmetl_cfsv2 /usr/local/bin
RUN chmod 744 /usr/local/bin/gmetl_cfsv2

COPY --chown=nhm rungmetl_cfs.py /usr/local/bin
RUN chmod 744 /usr/local/bin/rungmetl_cfs.py

USER $USER

WORKDIR /home/$USER

ENTRYPOINT ["/bin/bash", "-c", "/usr/local/bin/gmetl_cfsv2"]
