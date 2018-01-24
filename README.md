cepc/cvmfs-cepc
===============

A docker container with CVMFS installed and configured
for CEPC software.

## Usage

Start the container:

    docker run --privileged -i -t cepc/cvmfs-cepc

Select CEPC software version:

    cepcenv ls
    cepcenv use <version>
