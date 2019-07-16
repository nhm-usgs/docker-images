# `app` Directory

This directory contains the Docker source for building the National Hydrologic Model (NHM), multi-container application (a.k.a. "app").

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
