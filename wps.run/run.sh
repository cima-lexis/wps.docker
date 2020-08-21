#!/bin/bash

# This command execute WPS to pre-process data needed
# by the various workflow at LEXIS.
#
# It require three arguments, specified as environment variables
# or otherwise as command line arguments. when specified as command line arguments,
# the order of them should be WPS_START_DATE WPS_END_DATE WPS_MODE
#
# Arguments:
#
# - WPS_START_DATE: initial date/time of the simulation, in format YYYYMMDDHHNN
# - WPS_END_DATE: final date/time of the simulation, in format YYYYMMDDHHNN
# - WPS_MODE: kind of simulation to preprocess. accepts these values: 'WARMUP' 'WRF' 'WRFDA'
#   * WRF mode - preprocess the data needed to run a WRF simulation without data assimilation.
#               It's actually used by Continuum and numtech simulation.
#   * WRFDA mode - preprocess the data needed to run a WRFDA simulation with data assimilation.
#               It includes inthe preprocessed data instant WPS_START_DATE-3HOUR and WPS_START_DATE-6HOUR, that are
#               used during data assimilation. It will be used by Continuum and numtech simulations when
#               data assimilation will be used.
#   * WARMUP mode - preprocess the data needed to run three WRF simulation, without data assimilation.
#               Two of this WPS execution preprocess the data to run two WRF simulation for days WPS_START_DATE-1 and WPS_START_DATE-2.
#               These two set of data are the "warmup" data.
#               The other WPS execution prepares the normal WRF simulation from $WPS_START_DATE to $WPS_END_DATE
#               Warmup data it's actually used by Risico simulation.
#   * WARMUPDA mode - preprocess the data needed to run three WRF simulation, with data assimilation.
#               Two of this WPS execution preprocess the data to run two WRF simulation (with no assimilation) for days WPS_START_DATE-1
#               and WPS_START_DATE-2.
#               These two set of data are the "warmup" data.
#               The other WPS execution prepares the normal WRF simulation (with assimilation) from $WPS_START_DATE to $WPS_END_DATE
#               Warmup data it's actually used by Risico simulation.

# read arguments from command line
# or from environment.
if [ "$#" -eq 2 ]; then
  export wps_start=$1
  export wps_end=$2
  export wps_mode=$3
else
  export wps_start=$WPS_START_DATE
  export wps_end=$WPS_END_DATE
  export wps_mode=$WPS_MODE
fi


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



if [[ $WPS_MODE == 'WARMUP' ]]; then
  echo "PREPROCESS DATA FOR A WRF SIMULATION WITH WARMUP DATA"

  # include warmup data
  warmup1_start=`dateadd ${wps_start} "-2 day"`
  warmup2_start=`dateadd ${wps_start} "-1 day"`
  wrfrun_start=${wps_start}

  warmup1_end=$warmup2_start
  warmup2_end=$wrfrun_start
  wrfrun_end=$wps_end

  run_wps $warmup1_start $warmup1_end
  run_wps $warmup2_start $warmup2_end
  run_wps $wrfrun_start $wrfrun_end
  exit 0
fi

if [[ $WPS_MODE == 'WRF' ]]; then
  echo "PREPROCESS DATA FOR A WRF SIMULATION"
  run_wps $wps_start $wps_end
  exit 0
fi

if [[ $WPS_MODE == 'WRFDA' ]]; then
  echo "PREPROCESS DATA FOR A WRFDA SIMULATION"
  # include ($wps_start -3 hours) and
  # ($wps_start -6 hours) that are needed
  # for assimilation.
  wps_start=`dateadd ${wps_start} "-6 hours"`
  run_wps $wps_start $wps_end
  exit 0
fi

if [[ $WPS_MODE == 'WARMUPDA' ]]; then
  echo "PREPROCESS DATA FOR A WRFDA SIMULATION WITH WARMUP DATA"
  # include warmup data
  warmup1_start=`dateadd ${wps_start} "-2 day"`
  warmup2_start=`dateadd ${wps_start} "-1 day"`

  # include ($wps_start -3 hours) and
  # ($wps_start -6 hours) that are needed
  # for assimilation.
  wrfrun_start=`dateadd ${wps_start} "-6 hours"`

  warmup1_end=$warmup2_start
  warmup2_end=$wrfrun_start
  wrfrun_end=$wps_end

  run_wps $warmup1_start $warmup1_end
  run_wps $warmup2_start $warmup2_end
  run_wps $wrfrun_start $wrfrun_end
  exit 0
fi

echo Error: unknown mode $WPS_MODE
echo WPS_MODE accepts these values: 'WARMUP' 'WRF' 'WARMUPDA' 'WRFDA'
exit 1
