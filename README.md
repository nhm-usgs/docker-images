# USGS National Hydrologic Model (NHM), Docker Images
Code to build National Hydrologic Model, Docker images.

# Base Docker Image
The base Docker image is currently
[Anaconda](https://hub.docker.com/r/continuumio/anaconda3).

# Source Code Directory
Source code is installed under `/usr/local/src`. Currently, this is
[gridmetetl](https://github.com/nhm-usgs/gridmetetl),
[onhm-runners](https://github.com/nhm-usgs/onhm-runners),
[onhm-verify-eval](https://github.com/nhm-usgs/onhm-verify-eval), and
[PRMS](https://github.com/nhm-usgs/prms).

# Running

To run the app, run `build.sh`.

## Running on HPC Architecture

To build the Docker images in preparation for upload to
[Docker Hub](https://hub.docker.com/), run the script `build.sh`.

To upload the Docker images to Docker Hub, run the script `push.sh`.

This might take a while, especially if you are running it via a home
broadband connection.

Login to your HPC machine, and either clone the `docker-images` repo.:

```
git clone -b shifter https://github.com/nhm-usgs/docker-images.git
```

or run `git pull` to update your existing repo.:

```
cd docker-images
git pull
```

Now run the `pull.sh` script, to download and convert the Docker
images to Shifter images.

Be aware that at this time, Shifter pull errors are quite common, so
don't be surprised by `FAIL` messages from the `pull.sh` script. If
this happens, run the script again, and Shifter should pick up where
it left off. A new revision of Shifter promises to solve this problem.

When the required Shifter images are present, run the pipeline with
the command `run-shifter`.

The script will submit each container run to Slurm, and `stdout` from
the Slurm jobs will be directed to files in the current directory with
a `.out` suffix. Logs and error messages from each container run
should be saved in these files.

The `nhm.env` file (in this directory) contains environment variable
defaults that may need to be changed for testing purposes. Comments in
this file explain the function of each environment variable.
