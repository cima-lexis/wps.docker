set -e

# netcdf
cd /deps/Build_WRF/LIBRARIES/netcdf-4.1.3
./configure --prefix=$TARGET_DIR --disable-dap --disable-netcdf-4 --disable-shared
make
make install

# mpich
cd /deps/Build_WRF/LIBRARIES/mpich-3.0.4
./configure --prefix=$TARGET_DIR
make
make install

# jasper
cd /deps/Build_WRF/LIBRARIES/jasper-1.900.1
./configure --prefix=$TARGET_DIR
make
make install

# zlib
cd /deps/Build_WRF/LIBRARIES/zlib-1.2.7
./configure --prefix=$TARGET_DIR
make
make install

# libpng
cd /deps/Build_WRF/LIBRARIES/libpng-1.2.50
./configure --prefix=$TARGET_DIR
make
make install

# test dependencies
cd /deps/TESTS
cp $TARGET_DIR/include/netcdf.inc .
gfortran -c 01_fortran+c+netcdf_f.f
gcc -c 01_fortran+c+netcdf_c.c
gfortran 01_fortran+c+netcdf_f.o 01_fortran+c+netcdf_c.o -L$TARGET_DIR/lib -lnetcdff -lnetcdf
./a.out

mpif90 -c 02_fortran+c+netcdf+mpi_f.f
mpicc -c 02_fortran+c+netcdf+mpi_c.c
mpif90 02_fortran+c+netcdf+mpi_f.o 02_fortran+c+netcdf+mpi_c.o  -L$TARGET_DIR/lib -lnetcdff -lnetcdf
mpirun ./a.out

alias ftn='gfortran'

ln -fs /output/libs/include/* /usr/include/

# compile WRF
cd /deps/Build_WRF/WRF
echo 34 | ./configure
./compile em_real
cp -r . /output/WRF

# compile WPS
cd /deps/Build_WRF/WPS
./clean


echo 3 | ./configure
./compile
cp -r . /output/WPS-4.1
