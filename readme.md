# Docker container for the WPS model

This repo contains 4 Docker containers that together allow
to run the WPS model.

## Content of the repo

* gfs: empty dir that will contains files of gfs model
* ifs: empty dir that will contains files of ifs model
* namelist-prepare: go script to evaluate namelists templates
* WPS_GEOG: empty dir that will contains static GEO data
* wps.compile: Docker container to compile WPS, WRF and theirs relative dependencies
* wps.run: base container to run WPS (inherited by wps.gfs and wps.ifs)
* wps.gfs: container to run WPS based on input from gfs model
* wps.ifs: container to run WPS based on input from ifs model

## Build

To build the images, after you clone the repo locally:

### Build dependencies image

```bash
cd wps.compile
docker build .
docker tag <resulting image id> wps.compile
./run.sh
```

These commands builds all dependencies of WPS and WRF,
and put theme in ../wps.run where they will be add to
that image.

### Build base wps image

These commands will build the `wps.run` image, that
is the command parent of the two containers that will run:
`wps.ifs` and `wps.gfs`

```bash
cd wps.run
docker build .
docker tag <resulting image id> wps
```

### Build ifs and gfs WPS image

```bash
cd wps.gfs
docker build .
docker tag <resulting image id> wps.gfs
cd ../wps.ifs
docker build .
docker tag <resulting image id> wps.ifs
```

## Run ifs container

* make sure that `ifs` directory contains _ifs_ files for the day/s you want to forecast.
* make sure that WPS_GEOG directory contains static geo data for the run.
* start and end arguments should be in YYYYMMDDHH format, and they must corresponds with time the range of `ifs` files

```bash
cd wps.ifs
./run 2019101000 2019101200         # start and date and time of the time range to forecast.
```

## Run gfs container

* make sure that `gfs` directory contains _gfs_ files for the day/s you want to forecast.
* make sure that WPS_GEOG directory contains static geo data for the run.
* start and end arguments should be in YYYYMMDDHH format, and they must corresponds with time the range of `ifs` files

```bash
cd wps.gfs
./run 2019101000 2019101200         # start and date and time of the time range to forecast.
```
