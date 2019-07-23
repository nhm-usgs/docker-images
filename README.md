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

# Climate Data Interval

The climate data interval is specified by the variable `NUMDAYS`. The default value is 60. To change the number of days, pass the variable to the docker `run` command as follows:

```
bash docker run -e NUMDAYS=60
```
