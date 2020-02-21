FROM bitnami/minideb:stretch

# install dev pkg
RUN apt update
RUN apt install -y tcsh perl file libgfortran3 libpng16-16 less vim

RUN mkdir -p /wrfbase/wpswd/geogrid
ADD ./deps /deps

WORKDIR /wrfbase/wpswd

ADD run.sh run.sh
RUN ln -s /deps/WPS-4.1/geogrid.exe  .
RUN ln -s /deps/WPS-4.1/link_grib.csh .
RUN ln -s /deps/WPS-4.1/ungrib.exe  .
RUN ln -s /deps/WPS-4.1/metgrid.exe  .
RUN ln -s /deps/WPS-4.1/util/avg_tsfc.exe .
RUN ln -s /deps/WRF/main/real.exe .

ENV PATH=$PATH:/deps/libs/bin/
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/deps/libs/lib
CMD ["sh","run.sh"]

ADD namelist-prepare namelist-prepare
