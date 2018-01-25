#!/bin/sh

echo "::: Config /dev/fuse"
if [ ! -e /dev/fuse ]; then
  mknod -m 666 /dev/fuse c 10 229
fi
chmod a+rw /dev/fuse

echo "::: Cleaning autofs..."
rm -rf /var/run/autofs*

echo "::: cvmfs-config..."
cvmfs_config setup || exit 1

echo "::: Mounting FUSE..."
mount -a
echo "::: Mounting FUSE... [done]"

echo "::: Executing: \"$@\"..."
exec "$@"
