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

alias ftn='ifort'

ln -fs /output/libs/include/* /usr/include/

# compile WRF
cd /deps/Build_WRF/WRF
echo 15 | ./configure
./compile em_real
cp -r . /output/WRF

# compile WPS
cd /deps/Build_WRF/WPS
./clean


echo 19 | ./configure
./compile
cp -r . /output/WPS-4.1
