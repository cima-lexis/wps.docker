#!/bin/sh
outdir=$PWD/output
indir=$PWD/../gfs

mkdir -p $outdir

docker run -it \
-v $outdir:/output \
-v $indir:/input \
-v /vols/data/geog:/geogrid \
-e "WPS_START_DATE=$1" \
-e "WPS_END_DATE=$2" \
-e "WPS_MODE=$3" \
wps.gfs bash run.sh
