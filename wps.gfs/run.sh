#!/bin/sh
outdir=$PWD/output/$GFS_DS
indir=$PWD/../gfs/$GFS_DS

mkdir -p $outdir

docker run -it \
-v $outdir:/output \
-v $indir:/input \
-v /vols/data/geog:/geogrid \
-e "WPS_START_DATE=$1" \
-e "WPS_END_DATE=$2" \
wps.gfs bash run.sh
