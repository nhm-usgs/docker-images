# `app` Directory

This directory contains the [Docker Compose](https://docs.docker.com/compose/) source for building the National Hydrologic Model (NHM), multi-container application (a.k.a. "app").

# Running

To run the app, run:

```
docker-compose up --build
```

in this directory (the `app` directory). The Jupyter notebook can be found at [http://0.0.0.0:8888/notebooks/Proto_ONHM_runner_python_3.ipynb](http://0.0.0.0:8888/notebooks/Proto_ONHM_runner_python_3.ipynb).

# Logging in to the Container

To login to the running container, run:

```
docker exec -it prms /bin/bash
```

and you should end up in a bash shell inside the running container as `root`.
