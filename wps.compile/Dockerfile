FROM bitnami/minideb:stretch

RUN apt update
RUN apt install -y g++ file m4 wget vim less libg2-dev cpio ncurses-bin make tcsh perl

RUN mkdir -p /deps/Build_WRF/LIBRARIES
RUN mkdir -p /deps/TESTS

ENV PATH="/opt/intel/bin:${PATH}"

# test dev env
WORKDIR /deps/TESTS
RUN wget -q https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/Fortran_C_tests.tar
RUN tar -xf Fortran_C_tests.tar
ADD testfiles.sh testfiles.sh
#RUN sh testfiles.sh

CMD ["sh", "compile-deps.sh"]

# retrieve dependencies
WORKDIR /deps/Build_WRF/LIBRARIES
RUN wget -q https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/mpich-3.0.4.tar.gz
RUN wget -q https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/netcdf-4.1.3.tar.gz
RUN wget -q https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/jasper-1.900.1.tar.gz
RUN wget -q https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/libpng-1.2.50.tar.gz
RUN wget -q https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/zlib-1.2.7.tar.gz
RUN tar xzvf netcdf-4.1.3.tar.gz
RUN tar xzvf mpich-3.0.4.tar.gz
RUN tar xzvf jasper-1.900.1.tar.gz
RUN tar xzvf zlib-1.2.7.tar.gz     #or just .tar if no .gz present
RUN tar xzvf libpng-1.2.50.tar.gz     #or just .tar if no .gz present

#WORKDIR /deps/TESTS
RUN wget -q https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/Fortran_C_NETCDF_MPI_tests.tar
RUN tar -xf Fortran_C_NETCDF_MPI_tests.tar

ENV NETCDF=/output/libs
RUN mkdir -p /deps/Build_WRF/WRF
RUN mkdir -p /deps/Build_WRF/WPS

WORKDIR /deps/Build_WRF/WRF
RUN wget -q https://github.com/wrf-model/WRF/archive/v4.1.3.tar.gz
RUN tar --strip-components=1 -xvf v4.1.3.tar.gz

WORKDIR /deps/Build_WRF/WPS
RUN wget -q https://github.com/wrf-model/WPS/archive/v4.1.tar.gz
RUN tar --strip-components=1 -xvf v4.1.tar.gz
RUN sed -i 's/smooth_option = smth-desmth_special; smooth_passes=1/smooth_option = smth-desmth_special; smooth_passes=36/g' ./geogrid/GEOGRID.TBL.ARW

# prepare env
ENV DIR=/deps/Build_WRF/LIBRARIES
ENV CC=icc
ENV CXX=icc
ENV FC=ifort
ENV FCFLAGS=-m64
ENV F77=ifort
ENV FFLAGS=-m64
ENV TARGET_DIR=/output/libs
ENV LDFLAGS=-L$TARGET_DIR/lib
ENV CPPFLAGS=-I$TARGET_DIR/include
ENV CFLAGS=-I$TARGET_DIR/include
ENV PATH=$TARGET_DIR/bin:$PATH
ENV DEV_TOP=/deps/Build_WRF/WPS
RUN mkdir -p $TARGET_DIR
RUN mkdir -p /glade/u/home/wrfhelp/UNGRIB_LIBRARIES/
RUN ln -s $TARGET_DIR/lib /glade/u/home/wrfhelp/UNGRIB_LIBRARIES/
WORKDIR /deps

ADD compile-deps.sh compile-deps.sh
