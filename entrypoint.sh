#!/bin/sh

set -e

echo "::: Cleaning..."
rm -rf /var/run/autofs*

echo "::: cvmfs-config..."
cvmfs_config setup

echo "::: Executing: \"$@\"..."
exec "$@"
