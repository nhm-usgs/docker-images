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

## Running on HPC Architecture

Use [shifterimg](https://docs.nersc.gov/programming/shifter/how-to-use/) to pull and convert Docker images to Shifter images, which can
then be run via Slurm on HPC.

First, check to see if the necessary Shifter images are already present:

```
~> shifterimg images
denali-login2 docker     READY    40398d7101   2020-01-30T17:09:32 nhmusgs/data-loader:latest
denali-login2 docker     READY    b66260f62d   2020-02-07T12:19:13 nhmusgs/gridmet:latest
denali-login2 docker     READY    aba388047b   2020-02-04T18:06:03 nhmusgs/ncf2cbh:latest
denali-login2 docker     READY    c4fe4c3533   2020-01-29T15:19:05 nhmusgs/nhm-prms:latest
denali-login2 docker     READY    a57c28ccc1   2020-02-07T14:25:16 nhmusgs/ofp:latest
denali-login2 docker     READY    ecbd9618b4   2020-02-06T14:56:24 nhmusgs/out2ncf:latest
denali-login2 docker     READY    062f3a14dc   2020-02-06T16:35:08 nhmusgs/verifier:latest
```

If any of the Shifter images listed above are missing, you can try "pulling" them by running the `pull.sh`.
Be aware that at this time, Shifter pull errors are common, so don't be surprised by `FAIL` messages
from `shifterimg` in the output of this script. We are working with the Shifter team to debug this
now.

When the required Shifter images are present, run the pipeline with the command:


```
./compose-test.sh -s
```

The script will submit each container run to Slurm, and `stdout` from the Slurm jobs will be directed to files
in the current directory with a `.out` suffix. Logs and error messages from each container run should be saved
in these files.

The `nhm.env` file (in this directory) contains environment variable defaults that may need to be changed for
testing purposes. Comments in this file explain the function of each environment variable.

# Debugging

The `compose-test.sh` references environment variables that can be set to affect its execution for debugging purposes. They are:

* `GRIDMET_DISABLE`: set `true` to skip running gridmet service;
* `OFP_DISABLE`: set `true` to skip running ofp service;
* `END_DATE`: set to an [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) format date string to override calculation of run interval end date.

For example:

```
GRIDMET_DISABLE=true OFP_DISABLE=true END_DATE=2019-07-15 ./compose-test.sh
```
