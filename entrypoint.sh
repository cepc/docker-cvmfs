#!/bin/sh

echo "::: Cleaning..."
rm -rf /var/run/autofs*

echo "::: cvmfs-config..."
cvmfs_config setup || exit 1

echo "::: Mounting FUSE..."
mount -a
echo "::: Mounting FUSE... [done]"

echo "::: Executing: \"$@\"..."
exec "$@"
