#!/bin/sh

docker run -it                          \
     -v $PWD/../wps.run/deps:/output    \
     wps.compile
