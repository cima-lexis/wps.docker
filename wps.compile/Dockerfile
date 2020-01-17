FROM bitnami/minideb:stretch
RUN mkdir -p /deps/Build_WRF/LIBRARIES
RUN mkdir -p /deps/TESTS

# install dev pkg
RUN apt update
RUN apt install -y gcc gfortran musl-dev tcsh perl make g++ file m4 wget

# test dev env
WORKDIR /deps/TESTS
RUN wget -q https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/Fortran_C_tests.tar
RUN tar -xf Fortran_C_tests.tar
ADD testfiles.sh testfiles.sh
RUN sh testfiles.sh

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

WORKDIR /deps/TESTS
RUN wget -q https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/Fortran_C_NETCDF_MPI_tests.tar
RUN tar -xf Fortran_C_NETCDF_MPI_tests.tar

ENV NETCDF=/compiled_deps/deps
RUN mkdir -p /deps/Build_WRF/WRF
RUN mkdir -p /deps/Build_WRF/WPS

WORKDIR /deps/Build_WRF/WRF
RUN wget -q https://github.com/wrf-model/WRF/archive/v4.1.3.tar.gz
RUN tar --strip-components=1 -xvf v4.1.3.tar.gz

WORKDIR /deps/Build_WRF/WPS
RUN wget -q https://github.com/wrf-model/WPS/archive/v4.1.tar.gz
RUN tar --strip-components=1 -xvf v4.1.tar.gz

# prepare env
ENV DIR=/deps/Build_WRF/LIBRARIES
ENV CC=gcc
ENV CXX=g++
ENV FC=gfortran
ENV FCFLAGS=-m64
ENV F77=gfortran
ENV FFLAGS=-m64
ENV TARGET_DIR=/compiled_deps/deps
ENV LDFLAGS=-L$TARGET_DIR/lib
ENV CPPFLAGS=-I$TARGET_DIR/include
ENV CFLAGS=-I$TARGET_DIR/include
ENV PATH=$TARGET_DIR/bin:$PATH

RUN mkdir -p $TARGET_DIR
