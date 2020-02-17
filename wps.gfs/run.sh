#!/bin/sh

# read arguments from command line
# or from environment.
if [ "$#" -eq 2 ]; then
  export start=$1
  export end=$2
else
  export start=$WPS_START_DATE
  export end=$WPS_END_DATE
fi

docker run -it                      \
    -v $PWD/output:/output          \
    -v $PWD/../gfs/:/input          \
    -v /vols/data/geog:/geogrid    \
    wps.gfs sh run.sh $start $end