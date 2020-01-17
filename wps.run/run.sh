#!/bin/sh

# check input and environment validity

if [ ! -d /input ]; then
    echo "This container expect a volume mounted on /input containing input grib files"
    exit
fi

if [ ! -d /geogrid ]; then
    echo "This container expect a volume mounted on /geogrid containing geogrid static data files"
    exit
fi

if [ -z "$(ls -A /output)" ]; then
   echo;
else
   echo "This container expect a volume mounted on /output that must be empty"
   exit
fi

# preparing namelist files from templates.
export start=$1
export end=$2
cat namelist.input.tmpl | ./namelist-prepare $start $end > namelist.input
cat namelist.wps.tmpl | ./namelist-prepare $start $end > namelist.wps

# execute WPS
mpiexec -n 6 ./geogrid.exe
./link_grib.csh /input/*
./ungrib.exe
./avg_tsfc.exe
mpiexec -n 6 ./metgrid.exe
mpiexec -n 6 ./real.exe

# publish output files
cp wrfbdy_* wrfinput_* /output
