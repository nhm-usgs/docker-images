# `app` Directory

This directory contains the [Docker Compose](https://docs.docker.com/compose/) source for booting the National Hydrologic Model (NHM), multi-container application (a.k.a. "app").

# Running

To run the app, run:

```
docker-compose up --build
```

In the near future, it is not surprising for the build to fail due to exit statuses returned from the (rather complex) YUM mirror site indexing fall-back algorithm. If this happens, simply run the command above again (and again), and Docker Compose should pick up the process where it left off. The YUM exit status problem should be solved by creating our own Docker image eventually.

# Logging in to the Container

To login to the running container, run:

```
docker exec -it prms /bin/bash
```

and you should end up in a bash shell inside the running container as `root`.

# Building a Specific Release

The `Dockerfile` is accepts a `release` parameter, which can be used to build a specific container version. Currently, there are two versions of the container: `stable` (intended for production), and `unstable` (for development). The Docker Compose build defaults to `stable` (if the `release` parameter is not provided in the build). To build the `unstable` release, run:

```
docker-compose build --build-arg release=unstable
```

in this directory.
