#!/bin/sh

echo "::: Create /dev/fuse"
if [ ! -e /dev/fuse ]; then
  mknod -m 666 /dev/fuse c 10 229
fi

echo "::: Cleaning..."
rm -rf /var/run/autofs*

echo "::: cvmfs-config..."
cvmfs_config setup || exit 1

echo "::: Mounting FUSE..."
mount -a
echo "::: Mounting FUSE... [done]"

echo "::: Executing: \"$@\"..."
exec "$@"
