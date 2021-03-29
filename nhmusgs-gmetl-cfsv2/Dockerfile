FROM nhmusgs/base

LABEL maintainer="rmcd@usgs.gov"

# ARG VERSION_TAG_OFP=v0.1.6
ARG VERSION_TAG_GMETL_CFSV2=0.1

# download and install gridmetetl_s2s
ARG VERSION_GRIDMETETL_S2S=0.1
RUN wget --no-check-certificate -P $NHM_SOURCE_DIR https://github.com/rmcd-mscb/gridmet_cfsv2/archive/refs/tags/$VERSION_GRIDMETETL_S2S.tar.gz
RUN cd $NHM_SOURCE_DIR && tar -xzf $VERSION_GRIDMETETL_S2S.tar.gz
RUN mv $NHM_SOURCE_DIR/gridmet_cfsv2-$VERSION_GRIDMETETL_S2S $NHM_SOURCE_DIR/gridmet_cfsv2
RUN cd $NHM_SOURCE_DIR/gridmet_cfsv2 && pip --trusted-host pypi.org --trusted-host files.pythonhosted.org install .
RUN rm $NHM_SOURCE_DIR/$VERSION_GRIDMETETL_S2S.tar.gz

#download and install grid2shp
ARG VERSION_GRD2SHP=0.1.1
RUN wget --no-check-certificate -P $NHM_SOURCE_DIR https://github.com/nhm-usgs/grd2shp/archive/refs/tags/$VERSION_GRIDMETETL_S2S.tar.gz
RUN cd $NHM_SOURCE_DIR && tar -xzf $VERSION_GRD2SHP.tar.gz
RUN mv $NHM_SOURCE_DIR/grd2shp-$VERSION_GRD2SHP $NHM_SOURCE_DIR/grid2shp
RUN cd $NHM_SOURCE_DIR/grid2shp && pip --trusted-host pypi.org --trusted-host files.pythonhosted.org install .
RUN rm $NHM_SOURCE_DIR/$VERSION_GRD2SHP.tar.gz

# ofp script
COPY --chown=nhm gmetl_cfsv2 /usr/local/bin
RUN chmod 744 /usr/local/bin/gmetl_cfsv2

COPY --chown=nhm rungmetl_cfs.py /usr/local/bin
RUN chmod 744 /usr/local/bin/rungmetl_cfs.py

USER $USER

WORKDIR /home/$USER

ENTRYPOINT ["/bin/bash", "-c", "/usr/local/bin/gmetl_cfsv2"]
