#!/bin/sh

docker run -it                          \
     -v $PWD/../wps.run/deps:/output    \
     -v $PWD/../intel_c_compiler:/intel_c_compiler \
     -v $PWD/../opt_intel:/opt/intel \
     wps.compile.intel \
     bash
