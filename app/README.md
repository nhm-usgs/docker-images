# `app` Directory

This directory contains the [Docker Compose](https://docs.docker.com/compose/) source for building the National Hydrologic Model (NHM), multi-container application (a.k.a. "app").

# Running

To run the app, run:

```
docker-compose up --build
```

# Logging in to the Container

To login to the running container, run:

```
docker exec -it prms /bin/bash
```

and you should end up in a bash shell inside the running container as `root`.

# Climate Data Interval

The climate data interval is specified by the variable `days`. The default value is 60. To change the number of days, pass the variable to the docker `run` command as follows:

```
bash docker run -e NUMDAYS=60
```
