docker run -it -v $PWD/output:/output -v $PWD/../ifs/:/input -v $PWD/../WPS_GEOG:/geogrid wps.ifs sh run.sh $1 $2
