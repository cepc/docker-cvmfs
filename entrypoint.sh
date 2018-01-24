#!/bin/sh

set -e

echo "::: cvmfs-config..."
cvmfs_config setup

echo "::: executing: $@"
exec "$@"
