# `app` Directory

This directory contains the [Docker Compose](https://docs.docker.com/compose/) source for building the National Hydrologic Model (NHM), multi-container application (a.k.a. "app").

# Running

To run the app, run:

```
docker-compose up --build
```

# Logging in to the Containers

To login to the running PRMS container, run:

```
docker exec -it prms /bin/bash
```

To login to the running ofp container, run:

```
docker exec -it ofp /bin/bash
```

In both cases, you should end up in a bash shell inside the running container as `root`.

# Climate Data Interval

The climate data interval is specified by the variable `days`. The default value is 60. To change the number of days, pass the variable to the docker `run` command as follows:

```
bash docker run -e NUMDAYS=60
```
