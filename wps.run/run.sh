#!/bin/bash

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

# read arguments from command line
# or from environment.
if [ "$#" -eq 2 ]; then
  export start=$1
  export end=$2
else
  export start=$WPS_START_DATE
  export end=$WPS_END_DATE
fi

# prepares namelist files from templates.
cat namelist.input.tmpl | ./namelist-prepare $start $end > namelist.input
cat namelist.wps.tmpl | ./namelist-prepare $start $end > namelist.wps

# number of processor cores availables
export cores=`nproc`

# execute WPS
mpiexec -n 36 ./geogrid.exe
./link_grib.csh /input/*
./ungrib.exe
if ./needs-constants $start $end; then
  ./avg_tsfc.exe
fi
mpiexec -n $cores ./metgrid.exe
mpiexec -n $cores ./real.exe

# publish output files
cp wrfbdy_* wrfinput_* namelist.input /output
