docker run -it -v $PWD/output:/output -v $PWD/../gfs/:/input -v $PWD/../WPS_GEOG:/geogrid wps.gfssh run.sh $1 $2
