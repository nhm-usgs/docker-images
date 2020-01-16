# USGS National Hydrologic Model (NHM), Docker Images
Code to build National Hydrologic Model, Docker images.

# Base Docker Image
The base Docker image is currently [Anaconda](https://hub.docker.com/r/continuumio/anaconda3).

# Source Code Directory
Source code is installed under `/usr/local/src`. Currently, this is [onhm-fetcher-parser](https://github.com/nhm-usgs/onhm-fetcher-parser), [onhm-runners](https://github.com/nhm-usgs/onhm-runners), [onhm-verify-eval](https://github.com/nhm-usgs/onhm-verify-eval), and [PRMS](https://github.com/nhm-usgs/prms).

# Running

To run the app, run:

```
./compose-test.sh
```

## Running on Windows

We have not had success running the app on the Windows version of Docker. Whether this is due to the global network security configuration of Windows within .usgs.gov, or specific to Docker on Windows itself (or both), we are unsure.

If running the app on Windows within .usgs.gov, we recommend running Docker Compose on [Oracle VM VirtualBox](https://www.virtualbox.org/) (see below).

## Running on Oracle VM VirtualBox

1. install Oracle VM VirtualBox;
2. create a Linux virtual machine managed by Oracle VM VirtualBox using the installation image of distro. of your choice (we use [CentOS 7](https://www.centos.org/), but this is not required);
3. install Git, Docker Compose and wget on the Linux virtual machine;
4. clone the docker-images repo. on the virtual machine;
5. run the `compose-test.sh` script as described under **Running** above.

## Running on MPI Architecture

Use [shifterimg](https://docs.nersc.gov/programming/shifter/how-to-use/) to pull and convert Docker images to Shifter images:

```
shifterimg pull nhmusgs/data-loader:latest
```

And the [remaining required images](https://hub.docker.com/orgs/nhmusgs/repositories). Then:


```
./compose-test.sh -s
```

# Debugging

The `compose-test.sh` references environment variables that can be set to affect its execution for debugging purposes. They are:

* `GRIDMET_DISABLE`: set `true` to skip running gridmet service;
* `OFP_DISABLE`: set `true` to skip running ofp service;
* `END_DATE`: set to an [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) format date string to override calculation of run interval end date.

For example:

```
GRIDMET_DISABLE=true OFP_DISABLE=true END_DATE=2019-07-15 ./compose-test.sh
```
