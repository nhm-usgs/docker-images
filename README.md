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

# Running on Windows

We have not had success running the app on the Windows version of Docker. Whether this is due to the global network security configuration of Windows within .usgs.gov, or specific to Docker on Windows itself (or both), we are unsure.

If running the app on Windows within .usgs.gov, we recommend running Docker Compose on [Oracle VM VirtualBox](https://www.virtualbox.org/):

1. install Oracle VM VirtualBox;
2. create a Linux virtual machine managed by Oracle VM VirtualBox using the installation image of distro. of your choice (we use [CentOS 7](https://www.centos.org/), but this is not required);
3. install Git, Docker Compose and wget on the Linux virtual machine;
4. clone the docker-images repo. on the virtual machine;
5. run the `compose-test.sh` script as described under **Running** above.