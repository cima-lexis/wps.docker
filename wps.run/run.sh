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


# number of processor cores availables
export cores=`nproc`


# run_wps prepares the environment to run
# WPS processes for a range of hours specified
# and then run them.
# the function requires in input start and end
# of the date range to run, in format YYYYMMDDHH
# the function search input files in folder /input/<startdate>
# and save output in folder /output/<startdate>
function run_wps() {
  start=$1
  end=$2

  # prepares namelist files from templates.
  cat namelist.input.tmpl | ./namelist-prepare $start $end > namelist.input
  cat namelist.wps.tmpl | ./namelist-prepare $start $end > namelist.wps

  # geogrid run slowly when using more than 36 cores
  if [ $cores -gt 36 ]; then
    export geo_cores=36
  else
    export geo_cores=$cores
  fi

  # execute WPS
  mpiexec -n $geo_cores ./geogrid.exe
  ./link_grib.csh /input/$start/*
  ./ungrib.exe

  # constants file is needed only for simulation
  # that last more than 24H. They provide a way
  # to calculate daily averages of variables.
  if ./needs-constants $start $end; then
    ./avg_tsfc.exe
  fi
  mpiexec -n $cores ./metgrid.exe
  mpiexec -n $cores ./real.exe

  # publish output files
  mkdir -p /output/$start/
  cp wrfbdy_* wrfinput_* namelist.input /output/$start/
}

function dateadd() {
  dt=$1
  amount=$2
  date -u '+%Y%m%d%H' -d "${dt:0:4}-${dt:4:2}-${dt:6:2} ${dt:8:2}:00 UTC ${amount}"
}

# read arguments from command line
# or from environment.
# WPS_MODE accepts these values: 'RISICO' 'CONTINUUM' 'ADMS' 'WRFDA'
if [ "$#" -eq 2 ]; then
  export wps_start=$1
  export wps_end=$2
  export wps_mode=$3
else
  export wps_start=$WPS_START_DATE
  export wps_end=$WPS_END_DATE
  export wps_mode=$WPS_MODE
fi

if [[ $WPS_MODE == 'RISICO']]; then

  warmup1_start=`dateadd ${wps_start} "-2 day"`
  warmup2_start=`dateadd ${wps_start} "-1 day"`
  wrfrun_start=${wps_start}

  warmup1_end=$warmup2_start
  warmup2_end=$wrf_run_start
  wrf_run_end=$wps_end

  run_wps $warmup1_start $warmup1_end
  run_wps $warmup2_start $warmup2_end
  run_wps $wrfrun_start $wrf_run_end
  exit 0
fi

if [[ $WPS_MODE == 'CONTINUUM' || $WPS_MODE == 'ADMS' || $WPS_MODE == 'WRFDA' ]]; then
  # include ($wps_start -3 hours) and
  # ($wps_start -6 hours) that are needed
  # for assimilation.
  wps_start=`dateadd ${wps_start} -6 hours"`
  run_wps $wps_start $wps_end
  exit 0
fi

echo Error: unknown mode '$WPS_MODE'
echo WPS_MODE accepts these values: 'RISICO' 'CONTINUUM' 'ADMS' 'WRFDA'
exit 1
