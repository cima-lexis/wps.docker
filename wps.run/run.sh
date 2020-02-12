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

# stop on first error
set -e

# preparing namelist files from templates.
export start=$1
export end=$2
cat namelist.input.tmpl | ./namelist-prepare $start $end > namelist.input
cat namelist.wps.tmpl | ./namelist-prepare $start $end > namelist.wps

# number of processor cores availables
export cores=`nproc`

# execute WPS
mpiexec -n $cores ./geogrid.exe
./link_grib.csh /input/*
./ungrib.exe
./avg_tsfc.exe
mpiexec -n $cores ./metgrid.exe
mpiexec -n $cores ./real.exe

# publish output files
cp wrfbdy_* wrfinput_* namelist.input /output
