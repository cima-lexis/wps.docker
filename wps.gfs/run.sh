#!/bin/sh

docker run -it \
-v $PWD/output:/output \
-v $PWD/../gfs/:/input \
-v /vols/data/geog:/geogrid \
-e "WPS_START_DATE=$1" \
-e "WPS_END_DATE=$2" \
wps.gfs bash run.sh
